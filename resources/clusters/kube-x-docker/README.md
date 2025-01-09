# Docker Cluster

## About

This cluster will install and provision one docker node.


## Steps

### Env

```bash
export KUBE_X_CLUSTER_NAME=kube-x-docker
```


### Provision the container

```bash
source .envrc
dock-x run
```

> [!Important] Token needs to be unique in /tmp/var/lib/rancher
> If the token has changed, the data dir needs to be cleaned up
> ```bash
> rm -rf /tmp/var/lib/rancher
> ```

### Check inv

```bash
kube-x-cluster inv
```

### DNS

In your hosts files:
```hosts
127.0.0.1 traefik.kube-x.dev
127.0.0.1 dash.kube-x.dev
127.0.0.1 kube-x-local-server-01.kube-x.local kube-x-local-server-01
```

### TLS: Install the Root Ca

```bash
export CAROOT=./cert
mkcert -install
# Restart Chrome
# If it does not work
# Add ./cert/rootCA as Trusted CA Root Certificate manually
```
More info: see [cert](cert/README.md)



### Kube-X Cluster Installation

Create a k3s cluster
```bash
kube-x-cluster play
```

### Kube-X App Installation

```bash
kube-x-cluster-app install traefik
```


