# Cluster Kubee Chart


A `cluster chart` is a [kubee chart](kubee-helmet-chart.md)
that manages a [cluster](cluster.md)

## Driver

The driver is a script:
* called  `kubee-helmet-cluster-driver` 
* located in the `bin` directory.

This script may implement the following command:
* `play`    : install a Kubernetes distribution in the cluster hosts
* `upgrade` : upgrade the Kubernetes distribution in the cluster hosts
* `reboot`  : reboot the cluster hosts (ie operating system) in order
* `ping`    : test the connections to the hosts
* `conf`    : print the cluster configuration (driven by a custom `helm template` command).


## Default Cluster Chart

The default cluster chart is the [k3s-ansible cluster chart](../../resources/charts/stable/k3s-ansible).

## How to set a different cluster chart

The cluster chart value is set in the `chart` property of the [kubee cluster chart](../../resources/charts/stable/cluster/README.md)

Example: in your [cluster values file](cluster-values.md)
```yaml
cluster:
  chart: 'k3s-ansible'
```


