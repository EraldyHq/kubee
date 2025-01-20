# Prometheus Operator

## About

This `Kube-x` chart installs and configures:
* install the [prometheus operator](https://prometheus-operator.dev/) 
* install a prometheus server

## How to


### Get Access

2 methods:
* Kubectl Proxy:
  * Template: http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:prometheus:9090/proxy/
  * URL with prometheus as namespace: http://localhost:8001/api/v1/namespaces/prometheus/services/http:prometheus:9090/proxy/
* Ingress: https://$HOSTNAME


## Dev/Contrib

See [](contrib.md)