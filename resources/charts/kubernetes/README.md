# Kubernetes Kubee Chart


## About

This Kubee chart will install `Kubernetes`, exactly the [k3s Kubernetes distribution](https://docs.k3s.io/).


## Steps

* Verify the configuration
```bash
kubee --cluster clusterName helmet template kubernetes
```

* Play - Deploy Kubernetes on the cluster hosts (Repeatable install and configuration)
```bash
kubee --cluster clusterName helmet play kubernetes
```

## Upgrade

* Change the version in [values](values.yaml) and run

```bash
kubee --cluster clusterName helmet upgrade kubernetes
```

