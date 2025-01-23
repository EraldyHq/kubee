# Monitoring of the Kubernetes Component


## About

This [kube-x jsonnet chart](../../../docs/bin/kube-x-helm-x.md#what-is-a-jsonnet-kube-x-chart) installs monitoring for the core Kubernetes components:
* Api Server
* Core Dns
* Controller Manager
* Kubelet
* Scheduler


The following monitoring elements are installed for each:
* prometheus scrape configuration
* prometheus alerts
* prometheus rules
* and grafana dashboard
  * Kubernetes / API server
  * Kubernetes Kubelet 
  * Kubernetes / Persistent Volumes
  * Kubernetes / Scheduler
  * Kubernetes / Controller Manager

Kube-State-Metrics:
* Kubernetes / Compute Resources / Cluster

## Doc

* Metrics: https://monitoring.mixins.dev/kubernetes/

## Optional Prerequisites: Kube-x Chart Dependency

This `kube-x` charts should have been enabled and installed:
  * [Grafana](../grafana/README.md) for the dashboards
  * [Prometheus](../prometheus/README.md) for the prometheus scrape, alert and rules



## Dev/Contrib

See [Dev/Contrib](contrib.md)

## Support 
### Why no Etcd monitoring

Because k3s disables it by [default](https://docs.k3s.io/cli/server#database)
The following server flag needs to be set`--etcd-expose-metrics=true`.

### Why does tne scheduler dashboard check the api server job

With k3s, there is only one binary and the api server endpoint gives you metrics from:
* the `controller manager`
* and `scheduler`
