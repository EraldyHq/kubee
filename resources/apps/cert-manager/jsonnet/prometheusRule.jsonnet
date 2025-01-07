local certManager = import "cert-manager-mixin/mixin.libsonnet";
local values = std.extVar("values");

// Generate a Prometheus Alert object
{
    apiVersion: 'monitoring.coreos.com/v1',
    kind: 'PrometheusRule',
    metadata:
      { name: 'cert-manager-mixin-alert-rules' },
    spec: certManager {
            // https://github.com/imusmanmalik/cert-manager-mixin/blob/main/config.libsonnet
            _config+:: {
              grafanaExternalUrl: "https://" + values.kube_x.grafana.instance.hostname,
            },
          }.prometheusAlerts
}