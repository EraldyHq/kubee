# Prometheus example app

## About

This app is for demonstration purpose. 

It installs the Prometheus example app


## How to

### Develop the Manifest Ops

```bash
kubectl create namespace example
kubectl config set-context --current --namespace=example
kubectl apply -k .
```

### Delete

```bash
kubectl delete -k .
kubectl delete namespace example
```













