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

* Determine the kube-prometheus version (v0.14.0)
* Extract the version of `prometheusOperator` in [versions.json](https://github.com/prometheus-operator/kube-prometheus/blob/v0.14.0/jsonnet/kube-prometheus/versions.json)
* Install
```bash
jb install https://github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator@v0.76.2
```
* Set it in the appVersion of [Chart.yaml](Chart.yaml) - used by [Jsonnet script](jsonnet/multi/prometheus-operator-crds.jsonnet)

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
