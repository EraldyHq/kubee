local extValues = std.extVar('values');

local values = {
  prometheus_enabled: extValues.prometheus.enabled,
};

if !values.prometheus_enabled then {} else

  local mixin = (import 'mixin.libsonnet');
  (import 'kubee/mixin.libsonnet')({
    mixin: mixin,
    mixin_name: 'external-dns',
    grafana_hostname: '',
    grafana_name: '',
    grafana_enabled: false,
  })
