# Prometheus Alert Manager


## About
This is a `Kubee Chart` that installs `Prometheus Alert manager`.

`Prometheus Alert manager` receives alerts from Prometheus
and manage them, ie:
* silence, 
* group,
* aggregate
* route them to:
  * email
  * or an external incident management platform such as OpsGenie.

## Install

```bash
kubee-chart --cluster clusterName play alertmanager
```

## Inspect

The output of this chart can be inspected with:
```bash
# set debug (to not delete the created manifests in the jsonnet/out directory)
export BASHLIB_ECHO_LEVEL=4
kubee-chart -c clusterName template alertmanager > /tmp/all.yaml
```

## Chart Features

* Alert Notifications Channels
  * Email 
  * OpsGenie (if api_key is not null)
* Ingress (if hostname is not null)
* Monitoring:
  * Metrics Scraping 
  * [Alerts](https://runbooks.prometheus-operator.dev/runbooks/alertmanager/)
  * [Grafana Dashboard](https://monitoring.mixins.dev/alertmanager/#dashboards)

## How to adapt 

This `Kubee Chart` is a [Jsonnet Chart](../../../docs/bin/kubee-chart.md#what-is-a-jsonnet-kubee-chart). 
You can use it as Jsonnet dependency in your projects.

## Contrib

See [contrib/dev](contrib.md)

