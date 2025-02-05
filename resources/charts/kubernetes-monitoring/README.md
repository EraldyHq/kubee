# Kubernetes Monitoring


## About

This [kube-x jsonnet chart](../../../docs/bin/kube-x-helm-x.md#what-is-a-jsonnet-kube-x-chart) installs monitoring for the core systems Kubernetes components:
* Api Server
* Controller Manager
* Core Dns
* Kubelet
* Proxy
* Scheduler


The dashboards are using metrics from:
* Kubernetes System components
* `Kube-State-Metrics` exporter
* and `node-exporter`


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


## Metrics List

https://monitoring.mixins.dev/kubernetes/
where:
* `apiserver_xxx`: Api server metrics
* `kube_xxx`: Kubelet metrics:

## Alerts / Rules and Dashboard
* https://kubernetes.io/docs/reference/instrumentation/metrics/


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

### Why does the scheduler dashboard check the api server job and not the scheduler job ?

With k3s, there is only one binary.
The api server endpoint gives you metrics from:
* the `controller manager`
* `scheduler`
* and `proxy`
The kubelet endpoint gives you metrics from:
* the `cadvisor`

### Bucket

* Job: kubelet and api server
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