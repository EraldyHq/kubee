# Prometheus Alert Manager


## About
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
kube-x-helm-x --cluster clusterName play alertmanager
```

## Inspect

The output of this chart can be inspected with:
```bash
# set debug (to not delete the created manifests in the jsonnet/out directory)
export BASHLIB_ECHO_LEVEL=4
kube-x-helm-x -c clusterName template alertmanager > /tmp/all.yaml
```

## Chart Features

* Alert Notifications Channels
  * Email 
  * OpsGenie
* Ingress if hostname is not null
* Alert manager Monitoring:
  * Metrics Collection 
  * [Alerts](https://runbooks.prometheus-operator.dev/runbooks/alertmanager/)

## Contrib

See [contrib/dev](contrib.md)

