local certManager = import 'argo-cd-mixin/mixin.libsonnet';
local values = std.extVar('values');

// Generate a Prometheus Alert object
{
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PrometheusRule',
  metadata: {
    name: 'argocd-mixin-alert-rules',
  },
  spec: certManager {
    // https://github.com/imusmanmalik/cert-manager-mixin/blob/main/config.libsonnet
    _config+:: {
      grafanaUrl: 'https://' + values.kube_x.grafana.instance.hostname,
      argoCdUrl: 'https://' + values.kube_x.argocd.hostname,
    },
  }.prometheusAlerts,
}
