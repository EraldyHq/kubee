
local extValues = std.extVar('values');


local values = {

  namespace: extValues.namespace,
  version: extValues.version,
  rbac_enabled: extValues.prometheus.exporter_auth.kube_rbac_proxy.enabled,
  rbac_version: extValues.prometheus.exporter_auth.kube_rbac_proxy.version,
  reloader_version: extValues.reloader.version

};


local blackboxExporter = (import 'kubee/blackbox-exporter.libsonnet')(values);

// Returned Objects
{
  ['blackbox-exporter-' + name]:
    blackboxExporter[name]
  for name in std.objectFields(blackboxExporter)
  // filter out network policy otherwise no ingress from Traefik
  // Secret is managed apart as we allow also a ExternalSecrets
  //if !std.member(['NetworkPolicy', 'Secret'], blackboxExporter[name].kind)
}


// (import 'kubee/mixin-grafana.libsonnet')(values {
//  mixin: alertmanager.mixin,
//  mixin_name: 'alertmanager',
//  grafana_name: values.grafana_name,
//  grafana_folder_label: 'Alert Manager',
//})
