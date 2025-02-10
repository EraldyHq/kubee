// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Don't modify this script if you are not in the Kubee Utilities Promtheus Chart directory
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

  local folderName = std.asciiLower(values.mixin_name);

  // folderRef on Dashboard was not working
  // we used folderUid
  local folderUid = std.md5('folder' + folderName);

  // Resync: Reload if the dashboard or folder was deleted from grafana
  // https://grafana.github.io/grafana-operator/docs/overview/#resyncperiod
  // 10m by default
  // 0m: never poll for changes in the dashboards
  local syncPeriod = '10m';

  // Dashboard Folder
  // https://grafana.github.io/grafana-operator/docs/api/#grafanafolderspec
  local grafanaFolder = {
    apiVersion: 'grafana.integreatly.org/v1beta1',
    kind: 'GrafanaFolder',
    metadata: {
      name: folderName,  // Does not allow Uppercase
    },
    spec: {
      // Allow import from grafana instance in another namespace
      // https://github.com/grafana/grafana-operator/tree/master/examples/crossnamespace
      // https://grafana.github.io/grafana-operator/docs/examples/crossnamespace/readme/
      allowCrossNamespaceImport: true,
      resyncPeriod: syncPeriod,
      instanceSelector: {
        matchLabels: {
          dashboards: values.grafana_name,
        },
      },
      // If title is not defined, the value will be taken from metadata.name
      // Allow uppercase
      title: values.grafana_folder_label,
      // The Uid
      uid: folderUid,
    },
  };


  // Dashboard
  // https://grafana.github.io/grafana-operator/docs/api/#grafanadashboardspec
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
          resyncPeriod: syncPeriod,
          // Ref: https://grafana.github.io/grafana-operator/docs/dashboards/#select-the-folder-where-the-dashboard-will-be-deployed
          // Not folderRef was not working
          // folderRef: values.mixin_name, # Name of a `GrafanaFolder` resource in the same namespace
          folderUID: folderUid,
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
