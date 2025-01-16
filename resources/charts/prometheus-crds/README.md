# Prometheus CRDS


## About

This is a `kube-x` chart that install the CRDS of Prometheus Operator.


## Install

This chart is automatically installed when the [prometheus chart](../prometheus) is installed

You can also install it individually with:

```bash
kube-x-helm-x -n prometheus install prometheus-crds
```

## Inspect

The output of this chart can be inspected with:
```bash
kube-x-helm-x -n prometheus template prometheus-crds
```


## Dev / Contrib

This chart gets the CRDs from [Jsonnet](jsonnet/multi/prometheus-operator-crds.jsonnet)

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
  * `versions.prometheusOperator` to the prometheusOperator version (used by [Jsonnet script](jsonnet/multi/prometheus-operator-crds.jsonnet)

### Test

You can check the created manifest with:
```bash
rm -rf jsonnet/multi/manifests && \
  mkdir -p jsonnet/multi/manifests && \
  jsonnet -J vendor \
    --multi jsonnet/multi/manifests \
    "jsonnet/multi/prometheus-operator-crds.jsonnet"  \
    | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
```
