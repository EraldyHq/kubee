local values = std.extVar('values');

// To execute
// jsonnet -J vendor --string -e 'std.manifestYamlDoc((import "jsonnet/kube-prometheus.jsonnet"))' --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }"
//
// -m / --multi <dir>   Write multiple files to the directory and output a relative list files to stdout
// rm -rf manifests && mkdir -p manifests/setup && jsonnet -J vendor --multi manifests "jsonnet/multi/kube-prometheus.jsonnet" --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml' -- {}
// -m manifest :
// multi modes - RUNTIME ERROR: multi mode: top-level object was a string, should be an object whose keys are filenames and values hold the JSON for that file.
//
// rm -rf manifests && mkdir -p manifests/setup && jsonnet -J vendor --multi manifests "jsonnet/multi/kube-prometheus.jsonnet" --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" | xargs -I{} sh -c 'cat {} | yq eval -P -'
//
// With Ya
// jsonnet -m manifests your_file.jsonnet && \
// for file in manifests/*.json; do \
//  yq eval -P "$file" > "${file%.json}.yaml"; \
// done && rm -rf manifests/*.json
local kp =
  (import 'kube-prometheus/main.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/addons/anti-affinity.libsonnet') +
  // (import 'kube-prometheus/addons/managed-cluster.libsonnet') +
  // (import 'kube-prometheus/addons/node-ports.libsonnet') +
  // (import 'kube-prometheus/addons/static-etcd.libsonnet') +
  // (import 'kube-prometheus/addons/custom-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/external-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/pyrra.libsonnet') +
  {
    values+:: {
      common+: {
        namespace: values.kube_x.prometheus.namespace,
      },
    },
  };

{ 'setup/0namespace-namespace.json': kp.kubePrometheus.namespace } +
{
  ['setup/prometheus-operator-' + name + '.json']: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor' && name != 'prometheusRule'), std.objectFields(kp.prometheusOperator))
} //+
// { 'setup/pyrra-slo-CustomResourceDefinition': kp.pyrra.crd } +
// serviceMonitor and prometheusRule are separated so that they can be created after the CRDs are ready
//{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
//{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
//{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
//{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
//{ ['blackbox-exporter-' + name]: kp.blackboxExporter[name] for name in std.objectFields(kp.blackboxExporter) } +
//{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
//// { ['pyrra-' + name]: kp.pyrra[name] for name in std.objectFields(kp.pyrra) if name != 'crd' } +
//{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
//{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) }
//{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
//{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
//{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) }