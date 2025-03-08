# Contrib Dev


## Helm Charts Bootstrap

```bash
mkdir "charts"
ln -s $(realpath ../cluster) charts/kubee-cluster
mkdir "charts/kubee-alertmanager"
ln -s $(realpath ../alertmanager/Chart.yaml) charts/kubee-alertmanager/Chart.yaml
ln -s $(realpath ../alertmanager/values.yaml) charts/kubee-alertmanager/values.yaml
mkdir "charts/kubee-cert-manager"
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml
mkdir "charts/kubee-external-secrets"
ln -s $(realpath ../external-secrets/Chart.yaml) charts/kubee-external-secrets/Chart.yaml
ln -s $(realpath ../external-secrets/values.yaml) charts/kubee-external-secrets/values.yaml
mkdir "charts/kubee-grafana"
ln -s $(realpath ../grafana/Chart.yaml) charts/kubee-grafana/Chart.yaml
ln -s $(realpath ../grafana/values.yaml) charts/kubee-grafana/values.yaml
mkdir "charts/kubee-traefik"
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml
# Pull
helm pull https://github.com/dexidp/helm-charts/releases/download/dex-0.20.0/dex-0.20.0.tgz -d charts --untar
```

## Jsonnet Bootstrap

The [jsonnet project](../jsonnet/README.md) was bootstrapped with:
```bash
cd jsonnet
```
* The [kube-prometheus libs](../utilities/dl-dependency-scripts):
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
* Try it out with

* helmet
```bash
kubee helmet -n prometheus template prometheus --out
```


## How to



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

