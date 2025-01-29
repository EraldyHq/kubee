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

local secretValue = 'Secret';
local externalSecretValue = 'ExternalSecret';
local secretTypeDomain = [secretValue, externalSecretValue];

// Defaults are just here to give structure
// They should be all provided to be sure that there is no path problem
local kxDefaults = {
  cluster_name: error 'cluster_name should be provided (no empty string)',
  secret_type: error 'secret_type should be provided (Secret or ExternalSecret)',
  external_secret_store_name: error 'external_secret_store should be provided',
  prometheus_name: error 'prometheus name should be provided',
  prometheus_hostname: error 'prometheus hostname should be provided (empty string at minima)',
  prometheus_memory: error 'prometheus memory should be provided (50Mi for instance)',
  prometheus_retention: error 'prometheus retention should be provided',
  prometheus_scrape_interval: error 'prometheus scrape interval should be provided',
  prometheus_max_block_duration: error 'prometheus max_block_duration should be provided',
  cert_manager_enabled: error 'Cert manager enabled should be provided (false or true)',
  cert_manager_issuer_name: error 'Cert manager issuer name should be provided',  // Accessed and triggered when cert manager is enabled
  grafana_cloud_enabled: error 'grafana_cloud_enabled value property should be provided',
  grafana_cloud_password: error 'grafana_cloud_password value property should be provided',
  grafana_cloud_username: error 'grafana_cloud_username value property should be provided',
  grafana_cloudrelabel_keep_regex: error 'grafana_cloudrelabel_keep_regex value property should be provided',
  new_relic_enabled: error 'new_relic_enabled value property should be provided',
  new_relic_bearer: error 'new_relic_bearer value property should be provided',
  new_relic_relabel_keep_regex: error 'new_relic_relabel_keep_regex value property should be provided',
  new_relic_keep_regex: error 'new_relic_keep_regex value property should be provided',
  grafana_enabled: error 'grafana_enabled value property should be provided',
  grafana_folder: 'Prometheus',
  grafana_name: error 'grafana_name value property should be provided',
};


// Return the secret
local newRelicCloudSecret = function(bearer, secretType, externalStoreName, p)
  (
    if secretType == 'ExternalSecret' then
      {
        apiVersion: 'external-secrets.io/v1beta1',
        kind: 'ExternalSecret',
        metadata: p._metadata {
          name: kxNaming.newRelicSecretName,
        },
        spec: {
          // The store from where
          secretStoreRef: {
            name: externalStoreName,
            kind: 'ClusterSecretStore',
          },
          // The target define the secret created
          // and may be pre-processed via template
          target: {
            name: kxNaming.newRelicSecretName,  // Secret name in Kubernetes
            template: {
              metadata: {
                annotations: {
                  description: 'The Remote Write Credentials for Prometheus',
                },
              },
            },
          },
          // Mapping to local secret from remote secret
          data: [
            {
              secretKey: kxNaming.newRelicSecretBearerKey,  // Prop Name in the secret
              remoteRef: {
                key: kxNaming.newRelicSecretName,  // Name of the remote secret
                property: kxNaming.newRelicSecretBearerKey,  // Prop Name in the remote secret
              },
            },
          ],
        },
      }
    else
      {
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
          [kxNaming.newRelicSecretBearerKey]: std.base64(bearer),
        },
      }
  );

// Return the secret
local grafanaCloudSecret = function(username, password, secretType, externalStoreName, p)
  (
    if secretType == 'ExternalSecret' then
      {
        apiVersion: 'external-secrets.io/v1beta1',
        kind: 'ExternalSecret',
        metadata: p._metadata {
          name: kxNaming.grafanaCloudSecretName,
        },
        spec: {
          // The store from where
          secretStoreRef: {
            name: externalStoreName,
            kind: 'ClusterSecretStore',
          },
          // The target define the secret created
          // and may be pre-processed via template
          target: {
            name: kxNaming.grafanaCloudSecretName,  // Secret name in Kubernetes
            template: {
              metadata: {
                annotations: {
                  description: 'The Remote Write Credentials for Prometheus',
                },
              },
            },
          },
          // Mapping to local secret from remote secret
          data: [
            {
              secretKey: kxNaming.grafanaCloudSecretUserNameKey,  // Prop Name in the secret
              remoteRef: {
                key: kxNaming.grafanaCloudSecretName,  // Name of the remote secret
                property: kxNaming.grafanaCloudSecretUserNameKey,  // Prop Name in the remote secret
              },
            },
            {
              secretKey: kxNaming.grafanaCloudSecretPasswordKey,  // Prop Name in the secret
              remoteRef: {
                key: kxNaming.grafanaCloudSecretName,  // Name of the remote secret
                property: kxNaming.grafanaCloudSecretPasswordKey,  // Prop Name in the remote secret
              },
            },
          ],
        },
      }
    else
      {
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
          [kxNaming.grafanaCloudSecretUserNameKey]: std.base64(username),
          [kxNaming.grafanaCloudSecretPasswordKey]: std.base64(password),
        },

      }
  );

// mixin is not a function but an object
local dashboards = (import 'github.com/prometheus/prometheus/documentation/prometheus-mixin/mixin.libsonnet') {
  _config+:: {
    // Optout of multicluster
    showMultiCluster: false,
  },
}.grafanaDashboards;
local stripJson = function(name) std.substr(name, 0, std.length(name) - std.length('.json'));

// kpValues = values for kubernetes-prometheus
// kxValues = values for kube-x
function(kpValues, kxValues)
  local kxConfig = kxDefaults + kxValues;

  assert std.member(secretTypeDomain, kxConfig.secret_type) : "Value '" + kxConfig.secret_type + "' must be one of " + std.toString(secretTypeDomain);

  (import '../kube-prometheus/components/prometheus.libsonnet')(kpValues) {
    local p = self,
    // hidding (ie deleting) due to the :: hiding operaror
    roleBindingSpecificNamespaces:: null,
    roleSpecificNamespaces:: null,
    roleConfig:: null,
    roleBindingConfig:: null,
    networkPolicy:: null,  // We can't access prometheus from Traefik otherwise
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
          nonResourceURLs: [
            '/metrics',
            '/metrics/slis',  // to scrape SLIS (ie https://capi:6443/metrics/slis)
          ],
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
                      // 9090 is the good one - Not the reloader port 8080
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
        resources: {
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
        scrapeInterval: kxConfig.prometheus_scrape_interval,
        // Defines the intervals at which the ale
        // For consistencyrting rules are evaluated
        evaluationInterval: '30s',
        // Retention: How long to retain
        // For consistency the Prometheus data
        // becomes the following prometheus server argument --storage.tsdb.retention.time=24h
        retention: kxConfig.prometheus_retention,
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
        // Arguments to the prometheus server
        // CRD:https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.Argument
        // List (not complete: https://prometheus.io/docs/prometheus/latest/command-line/prometheus/
        additionalArgs: []
                        + (
                          if kxConfig.prometheus_max_block_duration == '2h' then [] else [
                            {
                              // Duration of block in memory
                              // Default to 2 hours (we gain 100Mb of memory)
                              // There is also a min storage.tsdb.min-block-duration
                              // https://github.com/prometheus-operator/prometheus-operator/issues/4414
                              // Not found in the official doc
                              // https://prometheus.io/docs/prometheus/latest/command-line/prometheus/
                              // but well documented on the internet and it works boy
                              name: 'storage.tsdb.max-block-duration',
                              value: kxConfig.prometheus_max_block_duration,
                            },
                            {
                              // The web says that it should be set to the same value as max_block_duration
                              // Not sure what it means.
                              // Not found in the official doc
                              // https://prometheus.io/docs/prometheus/latest/command-line/prometheus/
                              // Chat Gpt: min-block-duration determines how long Prometheus waits
                              // before converting the WAL (Write-Ahead Log) entries into TSDB blocks.
                              name: 'storage.tsdb.min-block-duration',
                              value: kxConfig.prometheus_max_block_duration,
                            },
                          ]
                        ),
        // overrideHonorLaels:false enforces honorLabels:true
        // ie don't create `exported_` metrics
        overrideHonorLabels: false,
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
                        [if kxConfig.grafana_cloudrelabel_keep_regex != '' then 'writeRelabelConfigs']: [
                          // Doc: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config
                          // Example: https://docs.newrelic.com/docs/infrastructure/prometheus-integrations/install-configure-remote-write/set-your-prometheus-remote-write-integration/#allow-deny
                          {
                            sourceLabels: ['__name__'],
                            regex: kxConfig.grafana_cloudrelabel_keep_regex,
                            action: 'keep',
                          },
                        ],
                      }] else []) +
                     (if kxConfig.new_relic_enabled then [{
                        // Doc: https://docs.newrelic.com/docs/infrastructure/prometheus-integrations/install-configure-remote-write/set-your-prometheus-remote-write-integration/#optional-prometheus-operator-configuration
                        // Make sure the API key is of the type `Ingest - License`
                        url: 'https://metric-api.newrelic.com/prometheus/v1/write?prometheus_server=' + kxConfig.cluster_name,

                        // spec: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#authorization
                        [if kxConfig.new_relic_relabel_keep_regex != '' then 'writeRelabelConfigs']: [
                          // Doc: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config
                          // Example: https://docs.newrelic.com/docs/infrastructure/prometheus-integrations/install-configure-remote-write/set-your-prometheus-remote-write-integration/#allow-deny
                          {
                            sourceLabels: ['__name__'],
                            regex: kxConfig.new_relic_relabel_keep_regex,
                            action: 'keep',
                          },
                        ],
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
    },
    [if kxConfig.grafana_cloud_enabled then 'grafanaCloudSecret']: grafanaCloudSecret(
      kxConfig.grafana_cloud_username,
      kxConfig.grafana_cloud_password,
      kxConfig.secret_type,
      kxConfig.external_secret_store_name,
      p
    ),
    [if kxConfig.new_relic_enabled then 'newRelicSecret']: newRelicCloudSecret(
      kxConfig.new_relic_bearer,
      kxConfig.secret_type,
      kxConfig.external_secret_store_name,
      p
    ),
    // Dashboard Folder
    [if kxConfig.grafana_enabled then 'grafanaFolder']: {
      apiVersion: 'grafana.integreatly.org/v1beta1',
      kind: 'GrafanaFolder',
      metadata: {
        name: 'prometheus-grafana-folder',  // Does not allow Uppercase
      },
      spec: {
        instanceSelector: {
          matchLabels: {
            dashboards: kxConfig.grafana_name,
          },
        },
        // If title is not defined, the value will be taken from metadata.name
        // Allow uppercase
        title: kxConfig.grafana_folder,
      },
    },

  } +
  // Dashboard
  (if !kxConfig.grafana_enabled then {} else
     {
       ['grafana-dashboard-' + stripJson(name)]: {
         apiVersion: 'grafana.integreatly.org/v1beta1',
         kind: 'GrafanaDashboard',
         metadata: {
           name: 'prometheus-grafana-' + stripJson(name),
         },
         spec:
           {
             // Allow import from grafana instance in another namespace
             // https://github.com/grafana/grafana-operator/tree/master/examples/crossnamespace
             // https://grafana.github.io/grafana-operator/docs/examples/crossnamespace/readme/
             allowCrossNamespaceImport: true,
             // https://grafana.github.io/grafana-operator/docs/overview/#resyncperiod
             // 10m by default
             // 0m: never poll for changes in the dashboards
             resyncPeriod: '0m',
             folder: kxConfig.grafana_folder,
             // https://grafana.github.io/grafana-operator/docs/overview/#instanceselector
             instanceSelector: {
               matchLabels: {
                 dashboards: kxValues.grafana_name,
               },
             },
             // std.manifestJson to output a Json string
             json: std.manifestJson(dashboards[name]),
           },
       }
       for name in std.objectFields(dashboards)
     })
