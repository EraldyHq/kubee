# Prometheus

## About

This `Kube-x` chart installs and configures:
* install the [prometheus operator](https://prometheus-operator.dev/) 
* install a prometheus server

## How to
### Install

```bash
kube-x-helm-x --cluster clusterName play prometheus
```


### Inspect

The output of this chart can be inspected with:
```bash
# set debug (to not delete the created manifests in the jsonnet/out directory)
export BASHLIB_ECHO_LEVEL=4
kube-x-helm-x -n prometheus template prometheus > /tmp/all.yaml
```

### Get Access

2 methods:
* Kubectl Proxy:
  * Template: http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:prometheus:9090/proxy/
  * URL with prometheus as namespace: http://localhost:8001/api/v1/namespaces/prometheus/services/http:prometheus:9090/proxy/
* Ingress: https://$HOSTNAME


## Dev/Contrib

See [](contrib.md)