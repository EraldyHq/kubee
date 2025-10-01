# K3s Upgrade

## About

This page shows you how to upgrade `k3s` on your cluster.

## Steps

### Choose the next minor version

#### Version

Kubernetes versions are expressed as x.y.z, where 
  * x is the major version, 
  * y is the minor version, 
  * and z is the patch version.

In Kubernetes versioning v1.32.2:

* 1 = major version
* 32 = minor version
* 2 = patch version

#### Don't mess with the Skew Policy

K3s follows the [Kubernetes version skew policy](https://kubernetes.io/releases/version-skew-policy/#supported-component-upgrade-order),
which requires that you not skip intermediate minor versions when upgrading K3s.
The policy for all Kubernetes distributions is to take single steps between minor versions - no skipping minors.

Skipping MINOR versions when upgrading is unsupported.
Ensure that your plan does not skip intermediate minor versions when upgrading.
https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/

The "don't skip intermediate minor versions" rule means:
* ❌ Don't go from 1.32.x → 1.34.x (skipping 1.33)
* ✅ Do go from 1.32.x → 1.33.x → 1.34.x (one minor version at a time)

### Go check the next minor version

https://github.com/k3s-io/k3s/releases

### Set the version in your cluster file

Set the version in your [cluster](cluster-values.md) file

Example:
```yaml
k3s_ansible:
  # https://github.com/k3s-io/k3s/releases
  version: 'v1.33.5+k3s1'
  token: '${KUBEE_INFRA_K3S_TOKEN}'
```

### Execute the cluster upgrade

Execute the cluster upgrade with the default [cluster chart](cluster-chart.md)
```bash
kubee --cluster clusterName cluster upgrade
# same as
# kubee --cluster clusterName --cluster-chart k3s-ansible cluster upgrade
```



