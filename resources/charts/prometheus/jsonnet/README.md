# Jsonnet Prometheus project

## About

The Jsonnet project for Prometheus on `Kubee` 

This is a modified configuration of [Kube-Prometheus](https://github.com/prometheus-operator/kube-prometheus) to delete the added security layer:
* no [RBAC Proxy sidecar](https://github.com/brancz/kube-rbac-proxy) to decrease memory footprint
* allow access to all namespaces by default. 


For dev info, see [contrib](../contrib.md)