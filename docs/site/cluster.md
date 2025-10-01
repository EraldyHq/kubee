# Kubee Cluster

A cluster is a directory that contains the following files:
* `.envrc`: the env file
* `values.yaml`: the [cluster values file](cluster-values.md) 
  * Note: environment defined in `.envrc` can be referenced with the `${MY_ENV}` literal.


## Upgrade

See [k3s-upgrade](k3s-upgrade.md)