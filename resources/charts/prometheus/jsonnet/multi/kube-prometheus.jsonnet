// To execute
// jsonnet -J vendor --string -e 'std.manifestYamlDoc((import "jsonnet/kube-prometheus.jsonnet"))' --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }"
//
// -m / --multi <dir>   Write multiple files to the directory and output a relative list files to stdout
// rm -rf jsonnet/multi/manifests && mkdir -p jsonnet/multi/manifests/setup && jsonnet -J vendor --multi jsonnet/multi/manifests "jsonnet/multi/kube-prometheus.jsonnet" --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
// -m manifest :
// multi modes - RUNTIME ERROR: multi mode: top-level object was a string, should be an object whose keys are filenames and values hold the JSON for that file.
//
// rm -rf manifests && mkdir -p manifests/setup && jsonnet -J vendor --multi manifests "jsonnet/multi/kube-prometheus.jsonnet" --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" | xargs -I{} sh -c 'cat {} | yq eval -P -'
//
// With Yq
// jsonnet -m manifests your_file.jsonnet && \
// for file in manifests/*.json; do \
//  yq eval -P "$file" > "${file%.json}.yaml"; \
// done && rm -rf manifests/*.json

local values =  {
    kube_x: {
        prometheus: {
            // The error is triggered as access time, not build time
            namespace: error 'must provide namespace',
            alertmanager: {
                enabled: error 'must provide alert manager enabled',
                hostname: ''
            },
            blackbox_exporter: {
                enabled: error 'must provide blackbox exporter enabled',
            },
            node_exporter:{
                enabled: error 'must provide node exporter enabled',
            }
        }
    }
} + (std.extVar('values'));


local kp =
  (import '../../vendor/github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/main.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/addons/anti-affinity.libsonnet') +
  // (import 'kube-prometheus/addons/managed-cluster.libsonnet') +
  // (import 'kube-prometheus/addons/node-ports.libsonnet') +
  // (import 'kube-prometheus/addons/static-etcd.libsonnet') +
  // (import 'kube-prometheus/addons/custom-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/external-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/pyrra.libsonnet') +
  {
    // kube-prometheus use `values` as this is similar to helm
    values+:: {
      common+: {
        namespace: values.kube_x.prometheus.namespace,
      },
      alertmanager+: {
        name: 'alertmanager', # main by default
        replicas: 1,
        resources: {
            limits: { cpu: '10m', memory: '50Mi' },
            requests: { cpu: '4m', memory: '50Mi' },
        },
      },
      kubeStateMetrics+: {
        resources:: {
            limits: { cpu: '10m', memory: '50Mi' },
            requests: { cpu: '4m', memory: '50Mi' },
        }
      }
    },
  };

// Function that create an alertmanager patch
local alertManagerPatch = ( if values.kube_x.prometheus.alertmanager.hostname != '' then
            {
                spec+: {
                    externalUrl: 'https://'+ values.kube_x.prometheus.alertmanager.hostname
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

{
  ['prometheus-operator-' + name ]: kp.prometheusOperator[name]
  // CRD are in the prometheus-crd charts
  for name in std.filter((function(name) kp.prometheusOperator[name].kind != 'CustomResourceDefinition'), std.objectFields(kp.prometheusOperator))
} +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
(if values.kube_x.prometheus.alertmanager.enabled then {
    ['alertmanager-' + name]: kp.alertmanager[name] + (if kp.alertmanager[name].kind == 'Alertmanager' then alertManagerPatch else {} )
    for name in std.objectFields(kp.alertmanager)
} else {}) +
(if values.kube_x.prometheus.blackbox_exporter.enabled then {
    ['blackbox-exporter-' + name]: kp.blackboxExporter[name]
    for name in std.objectFields(kp.blackboxExporter)
} else {}) +
//{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
// { ['pyrra-' + name]: kp.pyrra[name] for name in std.objectFields(kp.pyrra) if name != 'crd' } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) } +
(if values.kube_x.prometheus.blackbox_exporter.enabled then { ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } else {}) +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) }