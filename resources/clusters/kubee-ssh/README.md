# SSH / VPS Cluster

## About

This directory contains an example of an SSH / VPS [cluster](../../../docs/site/cluster-creation.md)

* The [.envrc](.envrc)
* The [Helmet cluster values file](values.yaml)

## Steps

### Provision the cluster

Provision the cluster with the Kubee Kubernetes Chart

```bash
kubee helmet play kubernetes
```

### Add the apps via the Kubee Charts

```bash
kubee helmet play traefik
```
