// Add the mixin
local extValues = std.extVar('values');

local values = {
  grafana_hostname: extValues.grafana.hostname,
  grafana_name: extValues.grafana.name,
  grafana_folder_label: 'ArgoCd',
  grafana_enabled: extValues.grafana.enabled,
  argocd_hostname: extValues.hostname,
};


local argoCdMixin = (import 'argo-cd-mixin/mixin.libsonnet') + {
  // https://github.com/imusmanmalik/cert-manager-mixin/blob/main/config.libsonnet
  _config+:: {
    grafanaUrl: 'https://' + values.grafana_hostname,
    argoCdUrl: 'https://' + values.argocd_hostname,
  },
};


(import 'kube-x/mixin.libsonnet')(
  values {
    mixin: argoCdMixin,
    mixin_name: 'argocd',
  }
)
