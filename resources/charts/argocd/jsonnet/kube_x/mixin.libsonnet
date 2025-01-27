// A kube-x mixin function
// to create the Kubernetes Manifests
// * PromtetheusRule from the Promtheuse Operator
// * GrafanaDashboard from the Grafana Operator

local defaultValues = {

  mixin_name: error 'mixin_name is required',  // Manifest name, does not allow Uppercase
  mixin: error 'mixin is required',
  grafana_hostname: error 'grafana_hostname is required',
  grafana_name: error 'grafana_name is required',  // for the grafana instance selection
  grafana_folder_label: error 'grafana_folder_label is required',
  grafana_enabled: error 'grafana_enabled is required',

};

// The function
function(params)

  local values = defaultValues + params;


  // Return obejct
  {
    'prometheus-rules': {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'PrometheusRule',
      metadata: {
        name: values.grafana_folder_name + '-monitoring-rules',
      },
      spec: {
        local r = if std.objectHasAll(values.mixin, 'prometheusRules') then values.mixin.prometheusRules.groups else [],
        local a = if std.objectHasAll(values.mixin, 'prometheusAlerts') then values.mixin.prometheusAlerts.groups else [],
        groups: a + r,
      },
    },
  }
  + if !values.grafana_enabled then {} else (import 'mixin-grafana.libsonnet')(values)
