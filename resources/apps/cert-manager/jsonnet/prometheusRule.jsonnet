local certManager = import "cert-manager-mixin/mixin.libsonnet";



// Generate a Prometheus Alert
{
    apiVersion: 'monitoring.coreos.com/v1',
    kind: 'PrometheusRule',
    metadata:
      { name: 'cert-manager-mixin-alert-rules' },
    spec: certManager {
            _config+:: {
              grafanaExternalUrl: 'https://grafana.eraldy.com',
            },
          }.prometheusAlerts
}