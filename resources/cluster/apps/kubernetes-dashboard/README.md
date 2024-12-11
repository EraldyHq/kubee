# A Sub-Chart of kubernetes-dashboard

## About
A sub-chart of kubernetes-dashboard

## Install

* Add repo and download dependency:
```bash
helm dependency build
# helm dependency update ???
```
* Verify
```bash
helm lint
```
* Install
```bash
# KUBE_X_APP_NAMESPACE=kubernetes-dashboard
helm upgrade --install -n $KUBE_X_APP_NAMESPACE --create-namespace kubernetes-dashboard .
# with kube-x
kube-x-helm upgrade --install --create-namespace kubernetes-dashboard .
```

## Features
### User

There is 2 admin roles:
* the `admin` role
* the `cluster-admin` role

This chart creates for now only a `cluster-admin` role.

### Ingress

The ingress cannot be protected with an authentication mechanism that uses the `Authenticate` HTTP header
such as the `basic auth` otherwise they conflict, and you get a `401` not authorized.


## Ref
https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard