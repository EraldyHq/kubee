# Kube-Prometheus

## About

This `kube-x` chart is a [customization of Kube Prometheus](https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/customizing.md).


It installs and configure:
* the [prometheus operator](https://prometheus-operator.dev/) - The Prometheus Operator provides Kubernetes native deployment and management of Prometheus and related monitoring components. 
* a prometheus instance
* a alertmanager instance
* the node exporter
* the push gateway
* the [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics)
* the [prometheus adapter](https://github.com/kubernetes-sigs/prometheus-adapter)
* [the following alerts](https://runbooks.prometheus-operator.dev/)


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


## Dev / Contrib

```bash
jb init
jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@v0.14.0
# then to get the manifest into jsonnet/multi/manifests
rm -rf jsonnet/multi/manifests && mkdir -p jsonnet/multi/manifests/setup && jsonnet -J vendor --multi jsonnet/multi/manifests "jsonnet/multi/kube-prometheus.jsonnet" --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
# or set debug (to not delete the created manifests) and use the template command of helm-x
export BASHLIB_ECHO_LEVEL=4
kube-x-helm-x template prometheus
```