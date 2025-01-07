local certManager = import 'cert-manager-mixin/mixin.libsonnet';
local values = std.extVar('values');

// Generate a GrafanaDashboard
// https://grafana.github.io/grafana-operator/docs/dashboards/
//
// To see the mixin dashboards
// jsonnet -J vendor -e '(import "cert-manager-mixin/mixin.libsonnet").grafanaDashboards' -m jsonnet
//
// To execute
// jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "jsonnet/grafanaDashboard.jsonnet"))'
//
// By default, the folder is the namespace name
{
  apiVersion: 'grafana.integreatly.org/v1beta1',
  kind: 'GrafanaDashboard',
  metadata: {
    name: 'cert-manager-mixin-dashboard'
  },
  spec:
    {
      // Allow import from grafana instance in another namespace
      // https://github.com/grafana/grafana-operator/tree/master/examples/crossnamespace
      allowCrossNamespaceImport: true,
      resyncPeriod: '30s',
      instanceSelector: {
        matchLabels: {
          dashboards: values.kube_x.grafana.instance.label,
        },
      },
      // std.manifestJson to output a Json string
      json: std.manifestJson(
            certManager {
               // https://github.com/imusmanmalik/cert-manager-mixin/blob/main/config.libsonnet
               _config+:: {},
             }.grafanaDashboards["overview.json"]
             ),
    },
}
