# Prometheus Operator

## About

This app install and configure:
* install the prometheus operator 
* and configure a prometheus server


The Prometheus Operator provides Kubernetes native deployment and management of Prometheus and related monitoring components.

https://prometheus-operator.dev/


## How to




### Check that the operator is up and running

```bash
kubectl wait --for=condition=Ready pods -l  app.kubernetes.io/name=prometheus-operator -n kube-prometheus
```

### Verify that the prometheus instance is up and running

```bash
kubectl get prometheus -n kube-prometheus
# continuously
kubectl get prometheus -n kube-prometheus -w  
```
```
NAME         VERSION   DESIRED   READY   RECONCILED   AVAILABLE   AGE
prometheus                       1       True         True        39s
```

### Get Access

2 methods:
* Kubectl Proxy: 
  * Template: http://localhost:8001/api/v1/namespaces/$NAMESPACE/services/http:prometheus:9090/proxy/
  * URL with prometheus as namespace: http://localhost:8001/api/v1/namespaces/prometheus/services/http:prometheus:9090/proxy/
* Ingress: https://$HOSTNAME



## CRD

https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-operator-crds