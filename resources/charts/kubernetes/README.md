# Kubernetes Kubee Chart


## About

This Kubee chart will install Kubernetes.

The chart will install the [k3s Kubernetes distribution](https://docs.k3s.io/)

## Installation

* Verify the configuration
```bash
kubee --cluster clusterName helmet template kubernetes
```

* Play
```bash
kubee --cluster clusterName helmet play kubernetes
```

## Upgrade

* Change the version 

```bash
kubee --cluster clusterName helmet upgrade kubernetes
```

