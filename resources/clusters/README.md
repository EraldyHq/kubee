# Cluster

## About

One directory, one cluster

## Steps

### Cluster Provisioning

In your `.envrc`
```bash
export KUBEE_CLUSTER_NAME=xxx
export KUBEE_CLUSTER_CONNECTION=ansible.builtin.ssh
export KUBEE_CLUSTER_API_SERVER_01_IP=x.x.x.x
```

* Install Kubernetes
```bash
kubee-cluster play
```

### App/Chart Installation

```bash
kubee-chart -c cluster-name install chart-name
```


