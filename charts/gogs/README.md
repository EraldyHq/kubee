# Kubee Chart of Gogs

## About

WIP: Not finished: Gogs needs access to the ssh port.

## Documentation

https://hub.docker.com/r/gogs/gogs/
https://github.com/gogs/gogs/tree/main/docker

## How to


### Develop

```bash
# once
kubectl create namespace gogs
# then
kubectl config set-context --current --namespace=gogs
kubectl apply -k .
```


