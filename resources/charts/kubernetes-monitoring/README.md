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



