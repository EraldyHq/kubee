# Prometheus Alert Manager


## About
The alert manager manages alerts created by the Prometheus server.

It can:
* aggregate them,
* silence them,
* route them to:
  * email 
  * or an external incident management platform such as OpsGenie. 

## Install

```bash
kube-x-helm-x --cluster clusterName alertmanager
```

## Inspect

The output of this chart can be inspected with:
```bash
# set debug (to not delete the created manifests in the jsonnet/out directory)
export BASHLIB_ECHO_LEVEL=4
kube-x-helm-x -n prometheus template alertmanager > /tmp/all.yaml
```

## Chart Features

* Alert Notifications Channels
  * Email 
  * OpsGenie
* Ingress
* Alert manager Monitoring:
  * Metrics Collection 
  * [Alerts](https://runbooks.prometheus-operator.dev/runbooks/alertmanager/)

## Contrib

See [contrib/dev](contrib.md)

