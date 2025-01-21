// Adapted from
// https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/refs/tags/v0.14.0/jsonnet/kube-prometheus/components/prometheus.libsonnet
// to go from a role to a clusterRole (ie allow all namespace)
// Prometheus Doc:
// https://prometheus-operator.dev/docs/platform/platform-guide/#deploying-prometheus
// For rbac service account, see:
//   https://prometheus-operator.dev/docs/platform/rbac/
//   https://prometheus-operator.dev/docs/platform/rbac/#prometheus-rbac

// For consistency
local kxNaming = {
  grafanaCloudSecretName: 'grafana-cloud',
  grafanaCloudSecretUserNameKey: 'prometheus-username',
  grafanaCloudSecretPasswordKey: 'prometheus-password',
  newRelicSecretName: 'new-relic',
  newRelicSecretBearerKey: 'bearer',
};

// Defaults
local kxDefaults = {
  prometheus_hostname: error 'prometheus hostname should be provided (empty string at minima)',
  prometheus_memory: error 'prometheus memory should be provided (50Mi for instance)',
  cert_manager_enabled: error 'Cert manager enabled should be provided (false or true)',
  cert_manager_issuer_name: error 'Cert manager issuer name should be provided',  // Accessed and triggered when cert manager is enabled
};

// kpValues = values for kubernetes-prometheus
// kxValues = values for kube-x
function(kpValues, kxValues)
  local kxConfig = kxDefaults + kxValues;
  local prometheus = (import '../vendor/github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator/prometheus.libsonnet')(kpValues);
  (import '../kube-prometheus/components/prometheus.libsonnet')(kpValues) {
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

    [if kxConfig.prometheus_hostname != '' then 'ingress']: {
      apiVersion: 'networking.k8s.io/v1',
      kind: 'Ingress',
      metadata: p._metadata {
        annotations+: {
          'traefik.ingress.kubernetes.io/router.entrypoints': 'websecure',
          'traefik.ingress.kubernetes.io/router.tls': 'true',
          /* Auth*/
          'traefik.ingress.kubernetes.io/router.middlewares': 'kube-system-traefik-dashboard-auth@kubernetescrd',
          // Issuer
          [if kxConfig.cert_manager_enabled then 'cert-manager.io/cluster-issuer']: kxConfig.cert_manager_issuer_name,
        },
      },
      spec: {
        rules: [
          {
            host: kxConfig.prometheus_hostname,
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
          hosts: [kxConfig.prometheus_hostname],
          secretName: 'prometheus-cert',
        }],
      },
    },
    // launch Prometheus deployment into your Kubernetes Cluster using a Prometheus resource defined by Prometheus Operator.
    // definition is here:
    // https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.Prometheus
    // or here in Github: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#prometheus
    // example: https://github.com/prometheus-operator/prometheus-operator/blob/main/example/user-guides/alerting/prometheus-example.yaml
    prometheus+: {
      spec+: {
        // Number of replicas of each shard to dep
        // For consistencyloy
        replicas: 1,  // could be 2 for HA, kxNaming to 1
        // Resources
        resources:: {
          requests: { memory: kxConfig.prometheus_memory },
          limits: { memory: kxConfig.prometheus_memory },
        },
        // serviceMonitor Selector
        serviceMonitorSelector: {},  // Select all configured ServiceMonitor resources using {}
        // Example to select all ServiceMonitors with the `team: frontend` label.
        // It enables the frontend team to create new `ServiceMonitors` and `Services`
        // without having to reconfigure the Prometheus object.
        //    matchLabels:
        //      team: frontend
        serviceMonitorNamespaceSelector: {},  // Select all namespace
        // Interval between consecutive scrap
        // For consistencyes.
        scrapeInterval: '30s',
        // Defines the intervals at which the ale
        // For consistencyrting rules are evaluated
        evaluationInterval: '30s',
        // Retention: How long to retain
        // For consistency the Prometheus data
        // becomes the following prometheus server argument --storage.tsdb.retention.time=24h
        retention: '24h',
        // The external URL under which the Prometheus service is externally available.
        // Implements the --web.external-url flag: https://prometheus.io/docs/prometheus/latest/command-line/prometheus/
        [if kxConfig.prometheus_hostname == '' then 'externalUrl']: 'https://' + kxConfig.prometheus_hostname,
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
          cluster: kxConfig.cluster_name,
        },
        // Remote Write to Grafana Cloud
        // Spec: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.RemoteWriteSpec
        remoteWrite: [] +
                     (if kxConfig.grafana_cloud_enabled then [{
                        url: 'https://prometheus-blocks-prod-us-central1.grafana.net/api/prom/push',
                        basicAuth: {
                          username: {
                            // For consistency
                            name: kxNaming.grafanaCloudSecretName,
                            // For consistencyg.grafanaCloudSecretName,
                            key: kxNaming.grafanaCloudSecretUserNameKey,
                          },
                          password: {
                            // For consistency
                            name: kxNaming.grafanaCloudSecretName,
                            // For consistencyg.grafanaCloudSecretName,
                            key: kxNaming.grafanaCloudSecretPasswordKey,
                          },
                        },
                      }] else []) +
                     (if kxConfig.new_relic_enabled then [{
                        // Doc: https://docs.newrelic.com/docs/infrastructure/prometheus-integrations/install-configure-remote-write/set-your-prometheus-remote-write-integration/#optional-prometheus-operator-configuration
                        // Make sure the API key is of the type `Ingest - License`
                        url: 'https://metric-api.newrelic.com/prometheus/v1/write?prometheus_server=' + kxConfig.cluster_name,
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
                            name: kxNaming.newRelicSecretName,
                            // The secret key to select
                            key: kxNaming.newRelicSecretBearerKey,
                          },
                        },
                      }] else []),
      },
      [if kxConfig.grafana_cloud_enabled then 'grafanaCloudSecret']: {
        apiVersion: 'v1',
        kind: 'Secret',
        metadata: p._metadata {
          name: kxNaming.grafanaCloudSecretName,
        },
        /*
         The values for all keys in the data field have to be base64-encoded strings.
         If the conversion to base64 string is not desirable, you can choose to specify the stringData field instead,
         which accepts arbitrary strings as values.
        */
        data: {
          [kxNaming.grafanaCloudSecretUserNameKey]: std.base64(kxConfig.grafana_cloud_prometheus_username),
          [kxNaming.grafanaCloudSecretPasswordKey]: std.base64(kxConfig.grafana_cloud_prometheus_password),
        },
      },
      [if kxConfig.new_relic_enabled then 'newRelicSecret']: {
        apiVersion: 'v1',
        kind: 'Secret',
        metadata: p._metadata {
          name: kxNaming.newRelicSecretName,
        },
        /*
         The values for all keys in the data field have to be base64-encoded strings.
         If the conversion to base64 string is not desirable, you can choose to specify the stringData field instead,
         which accepts arbitrary strings as values.
        */
        data: {
          [kxNaming.newRelicSecretBearerKey]: std.base64(kxConfig.new_relic_bearer),
        },
      },
    },
  }
