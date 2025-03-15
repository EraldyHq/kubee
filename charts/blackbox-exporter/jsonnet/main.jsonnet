
local extValues = std.extVar('values');


local values = {

  namespace: extValues.namespace,
  version: extValues.version,
  rbac_enabled: extValues.prometheus.exporter_auth.kube_rbac_proxy.enabled,
  rbac_version: extValues.prometheus.exporter_auth.kube_rbac_proxy.version,
  reloader_version: extValues.reloader.version,
  grafana_hostname: extValues.grafana.hostname,
  grafana_enabled: extValues.grafana.enabled,
  grafana_name: extValues.grafana.name,
  probe_failed_interval: extValues.probe_failed_interval

};


local blackboxExporter = (import 'kubee/blackbox-exporter.libsonnet')(values);
local mixin = (import 'blackbox-exporter-mixin/mixin.libsonnet') + {
            _config+:: {
              grafanaUrl: 'https://' + values.grafana_hostname,
              probeFailedInterval: values.probe_failed_interval
            },
          };
// Returned Objects
{
  ['blackbox-exporter-' + name]:
    blackboxExporter[name]
  for name in std.objectFields(blackboxExporter)
  // filter out network policy otherwise no ingress from Traefik
  // Secret is managed apart as we allow also a ExternalSecrets
  //if !std.member(['NetworkPolicy', 'Secret'], blackboxExporter[name].kind)
} +
(import 'kubee/mixin.libsonnet')(
  values {
    mixin: mixin,
    mixin_name: 'blackbox-exporter',
    grafana_name: values.grafana_name,
    grafana_folder_label: 'BlackBox Exporter',
    grafana_hostname: values.grafana_hostname,
    grafana_enabled: values.grafana_enabled
  }
)


