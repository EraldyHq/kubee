// Adapted from
// https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/refs/tags/v0.14.0/jsonnet/kube-prometheus/components/prometheus.libsonnet
// to go from a role to a clusterRole (ie allow all namespace)
// Prometheus Doc:
// https://prometheus-operator.dev/docs/platform/platform-guide/#deploying-prometheus
// For rbac service account, see:
//   https://prometheus-operator.dev/docs/platform/rbac/
//   https://prometheus-operator.dev/docs/platform/rbac/#prometheus-rbac


function(params, values)
  local prometheus = (import '../vendor/github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator/prometheus.libsonnet')(params);
  (import '../kube-prometheus/components/prometheus.libsonnet')(params) {
    local p = self,
    // delete, roleBindingSpecificNamespaces
    roleBindingSpecificNamespaces:: null,
    roleSpecificNamespaces:: null,
    roleConfig:: null,
    roleBindingConfig:: null,
    // Rbac ClusterRole comes from https://prometheus-operator.dev/docs/platform/rbac/#prometheus-rbac
    clusterRole: {
      apiVersion: 'rbac.authorization.k8s.io/v1',
      kind: 'ClusterRole',
      metadata: p._metadata,
      rules: [
        {
          apiGroups: [''],
          resources: ['nodes', 'nodes/metrics', 'services', 'endpoints', 'pods'],
          verbs: ['get', 'list', 'watch'],
        },
        {
          apiGroups: [''],
          resources: ['configmaps'],
          verbs: ['get'],
        },
        {
          apiGroups: ['discovery.k8s.io'],
          resources: ['endpointslices'],
          verbs: ['get', 'list', 'watch'],
        },
        {
          apiGroups: ['networking.k8s.io'],
          resources: ['ingresses'],
          verbs: ['get', 'list', 'watch'],
        },
        {
          nonResourceURLs: ['/metrics'],
          verbs: ['get'],
        },
      ],
    },

    [if values.kube_x.prometheus.hostname != '' then 'ingress']: {
      apiVersion: 'networking.k8s.io/v1',
      kind: 'Ingress',
      metadata: p._metadata {
        annotations+: {
          'traefik.ingress.kubernetes.io/router.entrypoints': 'websecure',
          'traefik.ingress.kubernetes.io/router.tls': 'true',
          /* Auth*/
          'traefik.ingress.kubernetes.io/router.middlewares': 'kube-system-traefik-dashboard-auth@kubernetescrd',
          // Issuer
          [if values.kube_x.cert_manager.enabled then 'cert-manager.io/cluster-issuer']: values.kube_x.cert_manager.defaultIssuerName,
        },
      },
      spec: {
        rules: [
          {
            host: values.kube_x.prometheus.hostname,
            http: {
              paths: [{
                backend: {
                  service: {
                    name: p._metadata.name,
                    port: {
                      number: 9090,
                    },
                  },
                },
                path: '/',
                pathType: 'Prefix',
              }],
            },
          },
        ],
        tls: [{
          hosts: [values.kube_x.prometheus.hostname],
          secretName: 'prometheus-cert',
        }],
      },
    },
    # launch Prometheus deployment into your Kubernetes Cluster using a Prometheus resource defined by Prometheus Operator.
    # definition is here:
    # https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.Prometheus
    # or here in Github: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#prometheus
    # example: https://github.com/prometheus-operator/prometheus-operator/blob/main/example/user-guides/alerting/prometheus-example.yaml
    prometheus+: {
      spec+: {
        // Number of replicas of each shard to deploy
        replicas: 1,  // could be 2 for HA, default to 1
        // Resources
        resources:: {
          requests: { memory: values.kube_x.prometheus.resources.memory },
          limits: { memory: values.kube_x.prometheus.resources.memory },
        },
        // serviceMonitor Selector
        serviceMonitorSelector: {},  // Select all configured ServiceMonitor resources using {}
        // Example to select all ServiceMonitors with the `team: frontend` label.
        // It enables the frontend team to create new `ServiceMonitors` and `Services`
        // without having to reconfigure the Prometheus object.
        //    matchLabels:
        //      team: frontend
        serviceMonitorNamespaceSelector: {},  // Select all namespace
        // Interval between consecutive scrapes.
        scrapeInterval: '30s',  // the default
        // Defines the intervals at which the alerting rules are evaluated
        evaluationInterval: '30s',  // the default
        // Retention: How long to retain the Prometheus data
        retention: '24h',  // the default
        // The external URL under which the Prometheus service is externally available.
        // Implements the --web.external-url flag: https://prometheus.io/docs/prometheus/latest/command-line/prometheus/
        [if values.kube_x.prometheus.hostname == '' then 'externalUrl']: 'https://' + values.kube_x.prometheus.hostname,
        // Rules selector
        // https://prometheus-operator.dev/docs/developer/alerting/#deploying-prometheus-rules
        ruleSelector: {},  // All rules objects, an empty label selector matches all objects
        ruleNamespaceSelector: {},  // All namespaces, an empty label selector matches all namespaces
        // ScrapeConfig (for scrape outside the cluster)
        scrapeConfigSelector: {},
        scrapeConfigNamespaceSelector: {},
        // ProbeConfig (for probes with blackbox exporter)
        probeSelector: {},
        probeNamespaceSelector: {},
        // The labels added to any time series or alerts
        // when communicating with external systems (federation, remote storage, Alertmanager)
        externalLabels: {
          cluster: values.kube_x.cluster.name,
        },
        // Remote Write to Grafana Cloud
        // Spec: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.RemoteWriteSpec
        remoteWrite: [] +
                     (if values.kube_x.prometheus.grafana_cloud.enabled then [{
                        url: 'https://prometheus-blocks-prod-us-central1.grafana.net/api/prom/push',
                        basicAuth: {
                          username: {
                            name: 'grafana-cloud',
                            key: 'prometheus-username',
                          },
                          password: {
                            name: 'grafana-cloud',
                            key: 'prometheus-password',
                          },
                        },
                      }] else []) +
                     (if values.kube_x.prometheus.new_relic.enabled then [{
                        // Doc: https://docs.newrelic.com/docs/infrastructure/prometheus-integrations/install-configure-remote-write/set-your-prometheus-remote-write-integration/#optional-prometheus-operator-configuration
                        // Make sure the API key is of the type `Ingest - License`
                        url: 'https://metric-api.newrelic.com/prometheus/v1/write?prometheus_server=' + values.kube_x.cluster.name,
                        /*
                          # spec: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#authorization
                        writeRelabelConfigs:
                          # Send only the phpfpm_* metrics
                          # Doc: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config
                          # Example: https://docs.newrelic.com/docs/infrastructure/prometheus-integrations/install-configure-remote-write/set-your-prometheus-remote-write-integration/#allow-deny
                          - sourceLabels: [ __name__ ]
                            regex: "(phpfpm|argocd|node|traefik)_(.*)"
                            action: keep
                          - sourceLabels: [ __name__ ]
                            regex: ^my_counter$
                            targetLabel: newrelic_metric_type
                            replacement: "counter"
                            action: replace
                         */
                        authorization: {
                          credentials: {
                            // The key of the secret to select from
                            name: 'newrelic',
                            // The secret key to select
                            key: 'prometheus-bearer',
                          },
                        },
                      }] else []),
      },
    },
  }
