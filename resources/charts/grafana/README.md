# Kube-X Grafana

## About

This app:
* installs the [Grafana Operator](#grafana-operator)
* instantiate a [Grafana Instance](templates/grafana-instance.yaml)
* add the [grafana-mixin](https://github.com/grafana/grafana/tree/main/grafana-mixin)


## Install

```bash
kubee- --cluster clusterName install grafana
```

## Values

* [Kube_x Instance](../kubee/values.yaml)
* [Grafana Operator](https://grafana.github.io/grafana-operator/docs/installation/helm/#values)

## Notes

### Doc

* [Grafana Operator Documentation](https://grafana.github.io/grafana-operator/)
* [Helm Documentation](https://grafana.github.io/grafana-operator/docs/installation/helm/)

External Grafana:
* [Grafana Cloud Usage Documentation](https://grafana.com/docs/grafana-cloud/developer-resources/infrastructure-as-code/grafana-operator/)

### CRD

CRD are packaged in their own chart.
[CRD Chart](../grafana-crds/README.md)

### Contrib/Dev

* Download dependency:
```bash
helm dependency update # update the dependencies (ie kubee if changed version or not)
```
* Test
```bash
helm lint
helm template -s templates/grafana-instance.yaml .
```

### Grafana Operator

`Grafana Operator` is a Kubernetes operator built to help you manage your Grafana instances and its resources from within Kubernetes.

The Operator can install and manage:
* local Grafana instances,
* Dashboards
* and Datasources
  through Kubernetes/OpenShift Custom resources.

The Grafana Operator automatically syncs the Kubernetes Custom resources and the actual resources in the Grafana Instance.