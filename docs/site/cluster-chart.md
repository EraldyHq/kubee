# Cluster Kubee Chart


A `cluster chart` is a [kubee chart](kubee-helmet-chart.md)
that manages a [cluster](cluster.md)

## Driver

The driver is a script:
* called  `kubee-driver` 
* located in the `bin` directory.

This script may implement the following command:
* `conf`      : print the cluster configuration (driven by a custom `source kubee-helmet-helm template` command).
* `ping`      : test the connections to the hosts
* `play`      : install a Kubernetes distribution in the cluster hosts
* `reboot`    : reboot the cluster hosts (ie operating system) in order
* `uninstall` : uninstall the Kubernetes distribution in the cluster hosts
* `upgrade`   : [upgrade the Kubernetes distribution](k3s-upgrade.md) in the cluster hosts


## Default Cluster Chart

The default cluster chart is the [k3s-ansible cluster chart](../../charts/k3s-ansible/README.md).

## How to set a different cluster chart

The cluster chart value is set in the `chart` property of the [kubee cluster chart](../../charts/cluster/README.md)

Example: in your [cluster values file](cluster-values.md)
```yaml
cluster:
  chart: 'k3s-ansible'
```
