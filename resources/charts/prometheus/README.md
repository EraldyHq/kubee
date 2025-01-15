# Kube-Prometheus


This app is a [customization of Kube Prometheus](https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/customizing.md).

It installs and configure:
* the prometheus operator (with a prometheus and alertmanager instance)
* the node exporter
* the push gateway
* [the following alerts](https://runbooks.prometheus-operator.dev/)


The Prometheus Operator provides Kubernetes native deployment and management of Prometheus and related monitoring components.

https://prometheus-operator.dev/

## Based

Base on kube-prometheus that bundles:
* the [kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin)


## Dev

```bash
jb init
jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@v0.14.0
```