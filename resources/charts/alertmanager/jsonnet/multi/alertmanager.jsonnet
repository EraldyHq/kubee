// To execute
// rm -rf jsonnet/multi/manifests && mkdir -p jsonnet/multi/manifests/setup && jsonnet -J vendor --multi jsonnet/multi/manifests "jsonnet/multi/kube-prometheus.jsonnet" --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}


local values =  {
    kube_x: {
        alertmanager: {
            enabled: error 'must provide alert manager enabled',
            namespace: error 'must provide alert manager namespace',
            hostname: ''
        },
    }
} + (std.extVar('values'));


// Function that create an alertmanager patch
local alertManagerPatch = ( if values.kube_x.alertmanager.hostname != '' then
            {
                spec+: {
                    externalUrl: 'https://'+ values.kube_x.alertmanager.hostname
                }
            }
            else
            {}
        ) + {
            spec+: {
                // Select all config Objects
                alertmanagerConfigSelector: {},
                // Select all namespace
                alertmanagerConfigNamespaceSelector: {},
                // By default, the alert manager had a matcher on the namespace
                // We disable this match ie
                // For a alertmanagerConfig in the namespace kube-prometheus, it would add to the route
                // matchers:
                //  - namespace="kube-prometheus"
                // See: https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.AlertmanagerConfigMatcherStrategy
                alertmanagerConfigMatcherStrategy: {
                    type: 'None'
                }
            }
        }
;

local jsonnetfile = (import '../../jsonnetfile.json');

local alertManagerVersion = std.filter(
    function(x) x.source.git.remote == "https://github.com/prometheus/alertmanager.git",
    jsonnetfile.dependencies)[0].version;


local alertmanager = (import '../lib/alertmanager.libsonnet')(
      {
        name: 'alertmanager', # main by default
        version: alertManagerVersion,
        namespace: values.kube_x.alertmanager.namespace,
        image: 'quay.io/prometheus/alertmanager:'+alertManagerVersion,
        replicas: 1, # default for an alert manager crd but for kube-prometheus
        resources: {
            limits: {}, // cpu: '10m', memory: '50Mi'
            requests: {},
        },
      }
);

{
    ['alertmanager-' + name]: alertmanager[name] + (if alertmanager[name].kind == 'Alertmanager' then alertManagerPatch else {} )
    for name in std.objectFields(alertmanager)
}
