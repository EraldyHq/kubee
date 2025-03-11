# Contrib Dev


## Helm Charts Bootstrap

```bash
task dep
```

## Jsonnet Bootstrap


The [jsonnet project](../jsonnet/README.md) was bootstrapped with:
```bash
cd jsonnet
```
* The [kube-prometheus libs](../utilities/dl-dependency-scripts). This jsonnet project is a tailored version of [kube-prometheus Prometheus (version 0.14.0)](https://github.com/prometheus-operator/kube-prometheus)
```bash
./dl-dependency-scripts
```
* The jsonnet bundler (as seen on the [kube-prometheus jsonnetfile.json](https://github.com/prometheus-operator/kube-prometheus/blob/main/jsonnet/kube-prometheus/jsonnetfile.json)
```bash
jb init
jb install github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator@main
jb install github.com/prometheus-operator/prometheus-operator/jsonnet/mixin@main
jb install github.com/kubernetes-monitoring/kubernetes-mixin@master # for alerts, dashboard for prometheus and prometheus operator
jb install github.com/prometheus/prometheus/documentation/prometheus-mixin@v3.1.0
```

## Dev
* Try it out with helmet
```bash
task tpl
```


## How to


### Get Access

2 methods:
* Kubectl Proxy:
    * Template: http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:prometheus:9090/proxy/
    * URL with prometheus as namespace: http://localhost:8001/api/v1/namespaces/prometheus/services/http:prometheus:9090/proxy/
* Ingress: https://$HOSTNAME

### Verify that the prometheus instance is up and running

```bash
kubectl get prometheus -n kube-prometheus
# continuously
kubectl get prometheus -n kube-prometheus -w  
```
```
NAME         VERSION   DESIRED   READY   RECONCILED   AVAILABLE   AGE
prometheus                       1       True         True        39s
```

### Check that the operator is up and running

```bash
kubectl wait --for=condition=Ready pods -l  app.kubernetes.io/name=prometheus-operator -n kube-prometheus
```


## CRD

See [](../../prometheus-crds/README.md)

## Why Not Full Kubernetes Prometheus

Because we want to be able to manage the installation granularity. No big bang.
When I installed the kubernetes-monitoring, the prometheus memory went to the roof (1G)
