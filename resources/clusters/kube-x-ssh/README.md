# SSH Cluster


## SSH Connection

```bash
export KUBE_X_CLUSTER_NAME=kube-x
export KUBE_X_CLUSTER_CONNECTION=ansible.builtin.ssh
export KUBE_X_CLUSTER_API_SERVER_01_IP=78.46.190.50
```

## Check Ansible Inventory

```bash
kube-x-cluster inv
```

### Kube-X App Installation

```bash
kube-x-cluster-app install traefik
kube-x-cluster-app install cert-manager
```
