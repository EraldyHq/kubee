# Prometheus Operator

## About

This app install and configure:
* the prometheus operator (with a prometheus and alertmanager instance)
* the node exporter
* the push gateway


The Prometheus Operator provides Kubernetes native deployment and management of Prometheus and related monitoring components.

https://prometheus-operator.dev/


## How to

### Develop the Manifest Ops

Once, create the namespace
```bash
kubectl create namespace kube-prometheus
```

Then:
* with `kube-x-kubectl`
```bash
kube-x-kubectl apply --server-side -k .
# why `--server-side` because https://github.com/prometheus-operator/kube-prometheus/issues/1511
```

* with `kubectl`
```bash
kubectl config set-context --current --namespace=kube-prometheus
kubectl apply --server-side -k .
# why `--server-side` because https://github.com/prometheus-operator/kube-prometheus/issues/1511
```

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

* Pushgateway:
  * Port Forwarding: `kubectl port-forward svc/pushgateway 9091`. 
    * http://localhost:9091
    * http://localhost:9091/metrics
  * Kubectl Proxy `kubectl proxy`: 
    * Metrics: http://localhost:8001/api/v1/namespaces/kube-prometheus/services/http:pushgateway:9091/proxy/metrics
    * Status: status page does not work (`display=none` on the node) when there is a path.
* Prometheus: 
  * Kubectl Proxy: http://localhost:8001/api/v1/namespaces/kube-prometheus/services/http:prometheus:9090/proxy/
  * Direct: https://prometheus.eraldy.com

### Delete all

See for more info: [Doc](https://github.com/prometheus-operator/prometheus-operator?tab=readme-ov-file#removal)
```bash
for n in $(kubectl get namespaces -o jsonpath={..metadata.name}); do
  kubectl delete --all --namespace=$n prometheus,servicemonitor,podmonitor,alertmanager
done

# After a couple of minutes 
# Delete the  operator itself
kubectl delete -f bundle.yaml

for n in $(kubectl get namespaces -o jsonpath={..metadata.name}); do
  kubectl delete --ignore-not-found --namespace=$n service prometheus-operated alertmanager-operated
done

kubectl delete --ignore-not-found customresourcedefinitions \
  prometheuses.monitoring.coreos.com \
  servicemonitors.monitoring.coreos.com \
  podmonitors.monitoring.coreos.com \
  alertmanagers.monitoring.coreos.com \
  prometheusrules.monitoring.coreos.com
```



## Node Exporter

Node exporter was added as a `DaemonSet` with `hostNetwork` capability.

See:
  * [prometheus-node-exporter](templates/prometheus-node-exporter.yml)
  * [prometheus-node-exporter service monitor](templates/prometheus-node-exporter-service-monitor.yml)

[Ref](https://www.civo.com/learn/kubernetes-node-monitoring-with-prometheus-and-grafana)



## CRD

https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-operator-crds