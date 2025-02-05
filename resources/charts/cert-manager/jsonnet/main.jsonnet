
local extValues = std.extVar('values');

local values = {
    grafana_hostname: extValues.grafana.hostname,
    grafana_name: extValues.grafana.name,
    grafana_enabled: extValues.grafana.enabled
};

local mixin = (import 'cert-manager-mixin/mixin.libsonnet') {
   // https://github.com/imusmanmalik/cert-manager-mixin/blob/main/config.libsonnet
   _config+:: {
     [ if values.grafana_hostname != '' then 'grafanaExternalUrl']: 'https://' + values.grafana_hostname,
   }
};


(import 'kubee/mixin.libsonnet')(values{
    mixin: mixin,
    mixin_name: 'cert-manager',
    grafana_folder_label: 'Cert Manager',
})