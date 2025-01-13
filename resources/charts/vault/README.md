# Kube-x Vault Chart

## About
A [kube-x chart](../../../docs/bin/kube-x-helm-x.md#what-is-a-kube-x-chart) that [installs Vault](https://developer.hashicorp.com/vault/docs/platform/k8s) in a standalone mode

## Installation

```bash
kube-x-helm-x --cluster cluster-name install vault
```

## Dev / Contrib

* Download dependency:
```bash
helm dependency build
```

* Install

```bash
# KUBE_X_APP_NAMESPACE=vault
helm upgrade --install -n vault --create-namespace vault .
# with kube-x
kube-x-helm upgrade --install --create-namespace vault .
```
