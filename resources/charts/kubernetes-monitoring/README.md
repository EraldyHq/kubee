# Monitoring of the Kubernetes Component


## About

This [kube-x jsonnet chart](../../../docs/bin/kube-x-helm-x.md#what-is-a-jsonnet-kube-x-chart) installs monitoring for the core Kubernetes components:
* Api Server
* Core Dns
* Controller Manager
* Kubelet
* Scheduler


The dashboards are using metrics from:
* Kubernetes components
* `Kube-State-Metrics` exporter
* and `node-exporter`


The following monitoring elements are installed for each:
* prometheus scrape configuration
* prometheus alerts and rules
  * `kubernetes-apps`: kube-state-metrics metrics
  * `kubernetes-resources`: kube-state-metrics metrics 
* and grafana dashboard
  * `Kubernetes / API server`
  * `Kubernetes Kubelet` 
  * `Kubernetes / Persistent Volumes`
  * `Kubernetes / Scheduler`
  * `Kubernetes / Controller Manager`



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

With k3s, there is only one binary.
The api server endpoint gives you metrics from:
* the `controller manager`
* and `scheduler`
The kubelet endpoint gives you metrics from:
* the `cadvisor`
