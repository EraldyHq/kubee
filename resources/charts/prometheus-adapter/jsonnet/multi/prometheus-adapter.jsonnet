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
        prometheus_adapter: {
            // The error is triggered as access time, not build time
            namespace: error 'must provide namespace',
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
      prometheusAdapter+:{
        resources:: {
          requests: {},
          limits: {},
        },
      },
    },
  };


{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) }