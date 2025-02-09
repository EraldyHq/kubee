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
* for the host/node (cpu/memory/storage) 


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
* prometheus alerts and rules
  * `kubernetes-apps`: kube-state-metrics metrics
  * `kubernetes-resources`: kube-state-metrics metrics
* and [grafana dashboards](https://monitoring.mixins.dev/kubernetes/#dashboards)
  * `Kubernetes / API server`
  * `Kubernetes Kubelet`
  * `Kubernetes / Persistent Volumes`
  * `Kubernetes / Scheduler`
  * `Kubernetes / Controller Manager`
  
### Kubernetes Metrics List

The [kubernetes mixin](https://monitoring.mixins.dev/kubernetes/) is installed
where:
* `apiserver_xxx`: Api server metrics
* `kubeexx`: Kubelet metrics:

The Kubernetes components metrics reference list is available [here](https://kubernetes.io/docs/reference/instrumentation/metrics/)


## Dev/Contrib

If you want to contribute to the development of this chart. Check [Dev/Contrib page](contrib.md)



### Bucket

Bucket are used for analytics query.

For instance: https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn/

The following metrics are dropped (on all scrape job - ie in the `kubelet` and `api server` job)
```
apiserver_request_duration_seconds_bucket{}	32809
apiserver_request_body_size_bytes_bucket{}	15744
apiserver_response_sizes_bucket{}	6176
apiserver_watch_events_sizes_bucket{}	2682
apiserver_request_sli_duration_seconds_bucket{}	26092
etcd_request_duration_seconds_bucket{}	22320
workqueue_work_duration_seconds_bucket{}	2002
workqueue_queue_duration_seconds_bucket{} 2002
```

