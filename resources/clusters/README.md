# Cluster

## About

One directory, one cluster

## Steps

### Cluster Provisioning

In your `.envrc`
```bash
export KUBE_X_CLUSTER_NAME=xxx
export KUBE_X_CLUSTER_CONNECTION=ansible.builtin.ssh
export KUBE_X_CLUSTER_API_SERVER_01_IP=x.x.x.x
```

* Install Kubernetes
```bash
kube-x-cluster play
```

### App/Chart Installation

```bash
kube-x-helm-x -c cluster-name install chart-name
```


