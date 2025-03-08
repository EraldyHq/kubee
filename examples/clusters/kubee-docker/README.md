# Docker Cluster

## About

This cluster will install and provision one docker node.


## Steps

### Env

```bash
export KUBEE_CLUSTER_NAME=kubee-docker
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
kubee helmet template kubernetes
```

### DNS

In your hosts files:
```hosts
127.0.0.1 traefik.kubee.dev
127.0.0.1 dash.kubee.dev
127.0.0.1 kubee-local-server-01.kubee.local kubee-local-server-01
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



### Kubee Cluster Installation

Create a k3s cluster
```bash
kubee helmet play kubernetes
```

### Kubee Chart Installation

```bash
kubee helmet play traefik
```


