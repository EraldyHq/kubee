local node = import 'node-mixin/mixin.libsonnet';
local values = std.extVar('values');

// Generate a Prometheus Alert object
{
'node-mixin-alert-rules':
    {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'PrometheusRule',
      metadata: {
        name: 'node-mixin-alert-rules',
      },
      spec: node {
        // https://github.com/prometheus/node_exporter/blob/master/docs/node-mixin/config.libsonnet
        _config+:: {
          clusterLabel: values.cluster.name,
          # This selector is added to all alerts
          nodeExporterSelector: 'service="node-exporter"',
        },
      }.prometheusAlerts,
    }
}
