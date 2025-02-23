# Kubernetes Monitoring


## About

This [kubee jsonnet chart](../../../docs/bin/kubee-helmet#what-is-a-jsonnet-kube-x-chart) installs monitoring for:
* the core systems Kubernetes components:
 * Api Server
 * Controller Manager
 * Core Dns
 * Kubelet
 * Proxy
 * Scheduler
* the host/node (cpu/memory/storage) 


## Installation

These `kubee` charts should have been enabled and installed:
* [Grafana](../grafana/README.md) if you want the dashboards
* [Prometheus](../prometheus/README.md) if you want the prometheus scrape, alert and rules


```bash
kubee helmet -c clusterName play kuberentes-monitoring
```


## Info

### Exporters

The dashboards are using metrics from:
* the `Kubernetes System components`
* the `Kube-State-Metrics` exporter
* the `node` exporter

### Prometheus Rules and Dashboard

The following monitoring elements are installed for each:
* prometheus scrape configuration
* [Kubernetes Rules and Grafana dashboards](https://monitoring.mixins.dev/kubernetes/)
* [Node Rules and Grafana dashboards](https://monitoring.mixins.dev/node-exporter/#dashboards)

### Kubernetes Metrics List

The [kubernetes mixin](https://monitoring.mixins.dev/kubernetes/) is installed
where:
* `apiserver_xxx`: Api server metrics
* `kubeexx`: Kubelet metrics:

The Kubernetes components metrics reference list is available [here](https://kubernetes.io/docs/reference/instrumentation/metrics/)


## Dev/Contrib

If you want to contribute to the development of this chart. Check [Dev/Contrib page](contrib/contrib.md)



