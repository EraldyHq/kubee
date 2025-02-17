
local kxExtValues = std.extVar('values');

if ! kxExtValues.prometheus.enabled then {}
else
(import 'kubee/mixin.libsonnet')({
    mixin_name: 'traefik',  // Manifest name, does not allow Uppercase
    mixin: (import './vendor/github.com/grafana/jsonnet-libs/traefik-mixin/mixin.libsonnet'),
    grafana_folder_label: 'Traefik',
    grafana_hostname: kxExtValues.grafana.hostname,
    grafana_enabled: kxExtValues.grafana.enabled,
    grafana_name: kxExtValues.grafana.name,  // for the grafana instance selection
})
