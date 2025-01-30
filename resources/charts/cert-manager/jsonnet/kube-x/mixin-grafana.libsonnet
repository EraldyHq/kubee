// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Don't modify this script if you are not in the Kube-X Utilities Promtheus Chart directory
// Otherwise this file will be overwritten
// as this is not the source
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!


// Return the grafana Folder and Dashboard CDRS for grafana operator
// from a mixin
// It's an individual libs because kube-prometheus separate them

local defaultValues = {

  mixin_name: error 'mixin_name is required',  // Manifest name, does not allow Uppercase
  mixin: error 'mixin is required',
  grafana_name: error 'grafana_name is required',  // for the grafana instance selection
  grafana_folder_label: error 'grafana_folder_label is required',

};

// Delete the json extension from the dashboard name and lowercase the name
// use it manifest name that should be a dns name
local stripJsonLowerCase = function(name) std.asciiLower(std.substr(name, 0, std.length(name) - std.length('.json')));

// The function
function(params)

  local values = defaultValues + params;

  // Dashboard Folder
  local grafanaFolder = {
    apiVersion: 'grafana.integreatly.org/v1beta1',
    kind: 'GrafanaFolder',
    metadata: {
      name: values.mixin_name,  // Does not allow Uppercase
    },
    spec: {
      // Allow import from grafana instance in another namespace
      // https://github.com/grafana/grafana-operator/tree/master/examples/crossnamespace
      // https://grafana.github.io/grafana-operator/docs/examples/crossnamespace/readme/
      allowCrossNamespaceImport: true,
      // https://grafana.github.io/grafana-operator/docs/overview/#resyncperiod
      // 10m by default
      // 0m: never poll for changes in the dashboards
      resyncPeriod: '0m',
      instanceSelector: {
        matchLabels: {
          dashboards: values.grafana_name,
        },
      },
      // If title is not defined, the value will be taken from metadata.name
      // Allow uppercase
      title: values.grafana_folder_label,
    },
  };


  // Dashboard
  local dashboards = if !std.objectHasAll(values.mixin, 'grafanaDashboards') then {} else {
    [values.mixin_name + '-grafana-dashboard-' + stripJsonLowerCase(name)]: {
      apiVersion: 'grafana.integreatly.org/v1beta1',
      kind: 'GrafanaDashboard',
      metadata: {
        name: values.mixin_name + '-grafana-' + stripJsonLowerCase(name),
      },
      spec:
        {
          // Allow import from grafana instance in another namespace
          // https://github.com/grafana/grafana-operator/tree/master/examples/crossnamespace
          // https://grafana.github.io/grafana-operator/docs/examples/crossnamespace/readme/
          allowCrossNamespaceImport: true,
          // https://grafana.github.io/grafana-operator/docs/overview/#resyncperiod
          // 10m by default
          // 0m: never poll for changes in the dashboards
          resyncPeriod: '0m',
          folder: values.mixin_name,
          // https://grafana.github.io/grafana-operator/docs/overview/#instanceselector
          instanceSelector: {
            matchLabels: {
              dashboards: values.grafana_name,
            },
          },
          // std.manifestJson to output a Json string
          json: std.manifestJson(values.mixin.grafanaDashboards[name]),
        },
    }
    for name in std.objectFields(values.mixin.grafanaDashboards)
  };

  // Returned objects
  {
    [values.mixin_name + '-grafana-folder']: grafanaFolder,
  } + dashboards
