# Kubee Vault Chart

## About
A [kubee chart](../../../docs/bin/kubee-helm-x.md#what-is-a-kubee-chart) that [installs Vault](https://developer.hashicorp.com/vault/docs/platform/k8s) 
in a standalone mode.

## Installation

```bash
kubee-helm-x --cluster cluster-name install vault
```

## Dev / Contrib

* Download dependency:
```bash
helm dependency build
```

* Install

```bash
# KUBEE_APP_NAMESPACE=vault
helm upgrade --install -n vault --create-namespace vault .
# with kubee
kubee-helm upgrade --install --create-namespace vault .
```
