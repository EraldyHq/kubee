# Contrib Dev

## About

This chart is a [kubee jsonnet chart](../../../docs/bin/kubee-chart.md#what-is-a-jsonnet-kubee-chart)

## Dependency

This chart has the following Jsonnet Dependencies:
* [kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin) - for Alerts and Dashboard
* [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus/tree/main/jsonnet/kube-prometheus) - for scrape config


## How this project was bootstrapped: Jsonnet Bootstrap

The [jsonnet project](jsonnet/README.md) was bootstrapped with:
```bash
cd jsonnet
```
* The [kube-prometheus libs](utilities/dl-kp-scripts-for-km):
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
```
* Try it out with
* Helm X
```bash
kubee-chart template kubernetes-monitoring --out > /tmp/all.yaml
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