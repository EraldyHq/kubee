# Dev / Contrib 


This chart gets the CRDs from [Jsonnet](jsonnet/main.jsonnet)
### Version

* Determine the `kube-prometheus version` in the [appVersion of the prometheus Chart.yaml](../prometheus/Chart.yaml) (v0.14.0)
* Use it in the URL to get the `versions.json` file:
    * https://github.com/prometheus-operator/kube-prometheus/blob/$KUBE_PROMETHEUS_VERSION/jsonnet/kube-prometheus/versions.json
    * Example: https://github.com/prometheus-operator/kube-prometheus/blob/v0.14.0/jsonnet/kube-prometheus/versions.json
* Extract the version of `prometheusOperator` from `versions.json`. For instance: `0.76.2`
* Install `prometheusOperator` as jsonnet dependency
```bash
jb install https://github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator@v0.76.2
```
* In [Chart.yaml](Chart.yaml):
    * set the appVersion to the kube-prometheus version
    * `versions.prometheusOperator` to the prometheusOperator version (used by [Jsonnet script](jsonnet/main.jsonnet)

### Test

You can check the created manifest with:
* Helm X
```bash
# set debug (to not delete the created manifests in the jsonnet/out directory)
export BASHLIB_ECHO_LEVEL=4
kubee-chart -n prometheus template prometheus-crds > jsonnet/out/all.yaml
```
* or Raw Jsonnet command
```bash
cd jsonnet
rm -rf out && \
  mkdir -p out && \
  jsonnet -J vendor \
    --multi out \
    "main.jsonnet"  \
    | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
```
