local certManager = import 'argo-cd-mixin/mixin.libsonnet';
local values = std.extVar('values');

// Generate a GrafanaDashboard
// https://grafana.github.io/grafana-operator/docs/dashboards/
//
// To see the mixin dashboards
// jsonnet -J vendor -e '(import "argo-cd-mixin/mixin.libsonnet").grafanaDashboards' -m jsonnet
//
// To execute
// jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "jsonnet/grafanaNotificationsDashboard.jsonnet"))' --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }"
//
// By default, the folder is the namespace name
{
  apiVersion: 'grafana.integreatly.org/v1beta1',
  kind: 'GrafanaDashboard',
  metadata: {
    name: 'argocd-mixin-notifications-dashboard'
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
          dashboards: values.kube_x.grafana.instance.label,
        },
      },
      // std.manifestJson to output a Json string
      json: std.manifestJson(
            certManager {
               // https://github.com/imusmanmalik/cert-manager-mixin/blob/main/config.libsonnet
               _config+:: {
                   grafanaUrl: 'https://' + values.kube_x.grafana.instance.hostname,
                   argoCdUrl: 'https://' + values.kube_x.argocd.hostname,
               },
             }.grafanaDashboards["argo-cd-notifications-overview.json"]
             ),
    },
}
