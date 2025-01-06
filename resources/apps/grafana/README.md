# Kube-X Grafana Operator

## About

[Grafana Operator](https://grafana.com/docs/grafana-cloud/developer-resources/infrastructure-as-code/grafana-operator/) is a Kubernetes operator built to help you manage your Grafana instances and its resources from within Kubernetes. 

The Operator can install and manage:
* local Grafana instances, 
* Dashboards 
* and Datasources 
through Kubernetes/OpenShift Custom resources.

The Grafana Operator automatically syncs the Kubernetes Custom resources and the actual resources in the Grafana Instance.



## Install

```bash
kube-x-cluster-app --cluster clusterName install grafana
```


## Notes

### CRD

[CRD Chart](../../crds/grafana/README.md)

### Contrib/Dev

* Download dependency:
```bash
helm dependency update # update the dependencies (ie kube-x if changed version or not)
```
* Test
```bash
helm lint
helm template -s templates/deployment.yaml .
```

### Install Doc

[Grafana](https://grafana.github.io/grafana-operator/docs/installation/)