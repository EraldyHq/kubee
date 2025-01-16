# Prometheus CRDS


## About

This is a `kube-x` chart that install the CRDS of Prometheus Operator.


## Install

This chart can be installed with:

```bash
kube-x-helm-x -n prometheus install prometheus-crds
```

This chart can be tested with:
```bash
kube-x-helm-x -n prometheus template prometheus-crds
```


## Dev / Contrib

This chart gets the CRD from [Jsonnet](jsonnet/multi/prometheus-operator-crds.jsonnet)

### Version

* Determine the kube-prometheus version (v0.14.0)
* Extract the version of `prometheusOperator` in [versions.json](https://github.com/prometheus-operator/kube-prometheus/blob/v0.14.0/jsonnet/kube-prometheus/versions.json)
* Install
```bash
jb install https://github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator@v0.76.2
```

### Test

You can check the created manifest with:
```bash
rm -rf jsonnet/multi/manifests && mkdir -p jsonnet/multi/manifests && jsonnet -J vendor --multi jsonnet/multi/manifests --ext-str "operatorPrometheusVersion=0.76.2" "jsonnet/multi/prometheus-operator-crds.jsonnet"  | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
```