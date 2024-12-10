# Dev note about kube-x-cluster


## Steps

### Download requirements

Install all requirements
```bash
ansible-galaxy install -r resources/cluster/kube-x/ansible-galaxy-requirements.yml
```

### Generate Inventory

#### Common

```bash
export KUBE_X_CLUSTER_API_SERVER_01_NAME=kube-x-server-01
export KUBE_X_CLUSTER_SERVER_USER=root
export KUBE_X_CLUSTER_APEX_DOMAIN=kube-x.local
export KUBE_X_CLUSTER_K3S_VERSION=v1.31.2+k3s1
export KUBE_X_CLUSTER_K3S_TOKEN=jbHWvQv9261KblczY7BX+OLcnZGrMSe+0UiFS3h7Ozc= # To generate a token: `openssl rand -base64 32 | tr -d '\n'`
```

#### Docker Connection

* Provision the container
```bash
# token needs to be unique in /tmp/var/lib/rancher 
rm -rf /tmp/var/lib/rancher
export DOCK_X_CONTAINER=$KUBE_X_CLUSTER_API_SERVER_01_NAME
export DOCK_X_REGISTRY=ghcr.io
export DOCK_X_NAMESPACE=gerardnico
export DOCK_X_NAME=kind-ansible
export DOCK_X_TAG=bookworm
# 8080 is to be able to forward a pod port
export DOCK_X_RUN_OPTIONS="-d --privileged --network kube -p 6443:6443 -p 80:80 -p 8080:8080 -p 443:443 -p 9100:9100 -v /tmp/var/lib/rancher:/var/lib/rancher --hostname $KUBE_X_CLUSTER_API_SERVER_01_NAME.$KUBE_X_CLUSTER_APEX_DOMAIN"
dock-x run
```

* [Connection](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_connection.html)

```bash
export KUBE_X_CLUSTER_NAME=kube-x-docker
export KUBE_X_CLUSTER_CONNECTION=community.docker.docker
export KUBE_X_CLUSTER_API_SERVER_01_IP=127.0.0.1
# check inv
kube-x-cluster inv
```

#### SSH Connection

```bash
export KUBE_X_CLUSTER_NAME=kube-x
export KUBE_X_CLUSTER_CONNECTION=ansible.builtin.ssh
export KUBE_X_CLUSTER_API_SERVER_01_IP=78.46.190.50
# check inv
kube-x-cluster inv
```


### Kube-X Installation

* Install k3s
```bash
kube-x-cluster play
```
