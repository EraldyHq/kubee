# Contrib Dev

## About

This chart is a [kubee jsonnet chart](../../../docs/bin/kubee-helmet#what-is-a-jsonnet-kubee-chart)

## Dependency

This chart has the following Jsonnet Dependencies:
* [kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin) - for Alerts and Dashboard
* [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus/tree/main/jsonnet/kube-prometheus) - for scrape config


## How this project was bootstrapped: Jsonnet Bootstrap

The [jsonnet project](../jsonnet/README.md) was bootstrapped with:
```bash
cd jsonnet
```
* The [kube-prometheus libs](dl-kp-scripts-for-km):
```bash
../utilities/dl-kp-scripts-for-km
```
* The jsonnet bundler (as seen on the [kube-prometheus jsonnetfile.json](https://github.com/prometheus-operator/kube-prometheus/blob/main/jsonnet/kube-prometheus/jsonnetfile.json)
```bash
jb init
jb install github.com/kubernetes-monitoring/kubernetes-mixin@master # last main commit
# Release branch	Kubernetes Compatibility	Prometheus Compatibility	Kube-state-metrics Compatibility
# compatibility     v1.26+	                    v2.11.0+                    v2.0+
jb install github.com/kubernetes/kube-state-metrics/jsonnet/kube-state-metrics@main
jb install github.com/kubernetes/kube-state-metrics/jsonnet/kube-state-metrics-mixin@main
jb install github.com/prometheus/node_exporter/docs/node-mixin@master
```
* Try it out with
* helmet
```bash
kubee -c clusterName helmet template kubernetes-monitoring --out > /tmp/all.yaml
```
* or Raw Jsonnet command
```bash
cd jsonnet
rm -rf out && mkdir -p out && jsonnet -J vendor \
  --multi out \
  "main.jsonnet"  \
  --ext-code "values={ kubee: std.parseYaml(importstr \"../../kubee/values.yaml\") }" \
  | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
```

## Support

### Kubelet SLI metrics not found

Happens only on Kubernetes v1.31
* Target Kubelet Sli Metrics at `:10250/metics/slis` is not found. `Error scraping target : server returned HTTP status 404 Not Found`
* Discussions: https://github.com/k3s-io/k3s/discussions/11637

### apiserver_request_duration_seconds_bucket drop bug

Bug in Kubernetes Prometheus with the dropping of `le` in the bucket
```jsonnet
{
    sourceLabels: ['__name__', 'le'],
    regex: 'apiserver_request_duration_seconds_bucket;(0.15|0.25|0.3|0.35|0.4|0.45|0.6|0.7|0.8|0.9|1.25|1.5|1.75|2.5|3|3.5|4.5|6|7|8|9|15|25|30|50)',
    # should be:
    regex: 'apiserver_request_duration_seconds_bucket;(0.15|0.25|0.3|0.35|0.4|0.45|0.6|0.7|0.8|0.9|1.25|1.5|1.75|2.5|3.0|3.5|4.5|6.0|7.0|8.0|9.0|15.0|25.0|30.0|50.0)',
    action: 'drop',
}
```

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

## Note

### Mixins

* [kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin)
* [prometheus-operator-mixin](https://github.com/prometheus-operator/prometheus-operator/tree/main/jsonnet/mixin)
* [kube-state-metrics-mixin](https://github.com/kubernetes/kube-state-metrics/tree/main/jsonnet/kube-state-metrics-mixin)
* [node-mixin](https://github.com/prometheus/node_exporter/tree/master/docs/node-mixin)
* [prometheus-mixin](https://github.com/prometheus/prometheus/tree/main/documentation/prometheus-mixin)
* [etd-mixin](https://github.com/etcd-io/etcd/tree/main/contrib/mixin)

> [Note]
> All mixins can be seen in [jsonnetfile.json](https://github.com/prometheus-operator/kube-prometheus/blob/main/jsonnet/kube-prometheus/jsonnetfile.json)

### Kube Rbac Proxy - Securing metrics on Exporter

In Kubernetes clusters without NetworkPolicies any Pod can perform requests to every other Pod in the cluster.
This proxy was developed in order to restrict requests to only those Pods,
that present a valid and RBAC authorized token or client TLS certificate.

Kube Rbac Proxy is a small
but potent HTTP proxy designed
to perform RBAC authorization
against the Kubernetes API using SubjectAccessReview.
It can act as a bridge between your service
and the outside world, ensuring that only authorized entities can access specific metrics.

This proxy is intended to be a sidecar that accepts incoming HTTP requests.
This way, one can ensure that a request is truly authorized,
instead of being able to access an application simply because an entity has network access to it.

https://ramesses2.medium.com/securing-http-services-with-kube-rbac-proxy-a-red-hat-journey-c080b5f0a42a

Deprecated: Replace the kube-rbac-proxy within Network Policies follow-up for potentially enhancements to protect the metrics endpoint
https://github.com/kubernetes-sigs/kubebuilder/blob/master/designs/discontinue_usage_of_kube_rbac_proxy.md

### Versions

See [versions.json](vendor/github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/versions.json)
They are imported in the [main.libsonnet](vendor/github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/main.libsonnet)
```json
{
  "alertmanager": "0.27.0",
  "blackboxExporter": "0.25.0",
  "grafana": "11.2.0",
  "kubeStateMetrics": "2.13.0",
  "nodeExporter": "1.8.2",
  "prometheus": "2.54.1",
  "prometheusAdapter": "0.12.0",
  "prometheusOperator": "0.76.2",
  "kubeRbacProxy": "0.18.1",
  "configmapReload": "0.13.1",
  "pyrra": "0.6.4"
}
```



### Why Not Grafana

`Kube-prometheus Grafana` implementation is based on [brancz/kubernetes-grafana](https://github.com/brancz/kubernetes-grafana)
that loads the [dashboards via file system mount](https://github.com/brancz/kubernetes-grafana/blob/5698c8940b6dadca3f42107b7839557bc041761f/grafana/grafana.libsonnet#L257)

We prefer the grafana operator because:
* we want to be able to create dashboard alongside our application,
* we can control grafana cloud instance
* `kubernetes-grafana` has already some [issues](https://github.com/prometheus-operator/kube-prometheus/issues/1735) and has not seen a commit for 2 years.

### Why Bucket are dropped by default

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

