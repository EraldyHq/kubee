# Prometheus

## About

This `Kubee` chart installs and configures:
* install the [prometheus operator](https://prometheus-operator.dev/) 
* install a prometheus server
* the [Prometheus Alert and dashboards](https://monitoring.mixins.dev/prometheus/#dashboards)
* the [Prometheus Operator Alerts](https://monitoring.mixins.dev/prometheus-operator/)
* the [General Alerting rules](https://runbooks.prometheus-operator.dev/runbooks/general/) (`AlertDown`, ...)

## How to

### Install

```bash
kubee-helm-x --cluster clusterName play prometheus
```


### Inspect

The output of this chart can be inspected with:
```bash
# set debug (to not delete the created manifests in the jsonnet/out directory)
export BASHLIB_ECHO_LEVEL=4
kubee-helm-x -n prometheus -c clusterName template prometheus > /tmp/all.yaml
```

### Get Access

2 methods:
* Kubectl Proxy:
  * Template: http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:prometheus:9090/proxy/
  * URL with prometheus as namespace: http://localhost:8001/api/v1/namespaces/prometheus/services/http:prometheus:9090/proxy/
* Ingress: https://$HOSTNAME


## Dev/Contrib

See [](contrib.md)