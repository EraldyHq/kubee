# Contrib Dev

## Dependency

This chart has the following Jsonnet Dependencies:
* [kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin) - for Alerts and Dashboard
* [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus/tree/main/jsonnet/kube-prometheus) - for scrape config


## How this project was bootstrapped: Jsonnet Bootstrap

The [jsonnet project](jsonnet/README.md) was bootstrapped with:
```bash
cd jsonnet
```
* The [kube-prometheus libs](utilities/dl-kp-scripts-for-km):
```bash
../utilities/dl-kp-scripts-for-km
```
* The jsonnet bundler (as seen on the [kube-prometheus jsonnetfile.json](https://github.com/prometheus-operator/kube-prometheus/blob/main/jsonnet/kube-prometheus/jsonnetfile.json)
```bash
jb init
jb install github.com/kubernetes-monitoring/kubernetes-mixin@master # last main commit
# Release branch	Kubernetes Compatibility	Prometheus Compatibility	Kube-state-metrics Compatibility
# compatibility     v1.26+	                    v2.11.0+                    v2.0+
```
* Try it out with
* Helm X
```bash
# set debug (to not delete the created manifests in the jsonnet/out directory)
export BASHLIB_ECHO_LEVEL=4
kube-x-helm-x template kubernetes-monitoring > /tmp/all.yaml
```
* or Raw Jsonnet command
```bash
cd jsonnet
rm -rf out && mkdir -p out && jsonnet -J vendor \
  --multi out \
  "main.jsonnet"  \
  --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" \
  | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
```
