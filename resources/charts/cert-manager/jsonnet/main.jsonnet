local certManager = import 'cert-manager-mixin/mixin.libsonnet';
local values = std.extVar('values');

// Generate a GrafanaDashboard
// https://grafana.github.io/grafana-operator/docs/dashboards/
//
// To see the mixin dashboards
// jsonnet -J vendor -e '(import "cert-manager-mixin/mixin.libsonnet").grafanaDashboards' -m jsonnet
//
// To execute
// jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "jsonnet/grafanaDashboard.jsonnet"))' --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }"
//
// By default, the folder is the namespace name
{
  'grafana-dashoard': {
    apiVersion: 'grafana.integreatly.org/v1beta1',
    kind: 'GrafanaDashboard',
    metadata: {
      name: 'cert-manager-mixin-dashboard',
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
        // https://grafana.github.io/grafana-operator/docs/overview/#instanceselector
        instanceSelector: {
          matchLabels: {
            dashboards: values.kube_x.grafana.label,
          },
        },
        // std.manifestJson to output a Json string
        json: std.manifestJson(
          certManager {
            // https://github.com/imusmanmalik/cert-manager-mixin/blob/main/config.libsonnet
            _config+:: {},
          }.grafanaDashboards['overview.json']
        ),
      },
  },
  // Generate a Prometheus Alert object
  'prometheus-rule':
    {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'PrometheusRule',
      metadata: {
        name: 'cert-manager-mixin-alert-rules',
      },
      spec: certManager {
        // https://github.com/imusmanmalik/cert-manager-mixin/blob/main/config.libsonnet
        _config+:: {
          grafanaExternalUrl: 'https://' + values.kube_x.grafana.hostname,
        },
      }.prometheusAlerts,
    },
}
