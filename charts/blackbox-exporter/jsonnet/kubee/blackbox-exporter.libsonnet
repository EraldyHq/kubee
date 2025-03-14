// blackbox metrics customization
// that delete Rbac container
//

local defaults = {
  namespace: error 'namespace is not specified',
  version: error 'version is not specified',
  rbac_enabled: error 'rbac_enabled is not specified',
  rbac_version: error 'rbac_version is not specified',
  reloader_version: error 'reloader_version is not specified',
};


function(params)

  local values = defaults + params;


  local blackBoxExporterVariable = (import '../kube-prometheus/components/blackbox-exporter.libsonnet')(values{
    image: 'quay.io/prometheus/blackbox-exporter:v' + values.version,
    configmapReloaderImage: 'ghcr.io/jimmidyson/configmap-reload:v' + values.reloader_version,
    kubeRbacProxyImage: 'quay.io/brancz/kube-rbac-proxy:v' + values.rbac_version,
  });

  blackBoxExporterVariable
