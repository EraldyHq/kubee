# SSH Cluster

## About

This directory contains an example of a SSH cluster. 

## Steps

### Create your clusters directory

A `clusters directory` is a directory that contains one or more cluster directory.

In your `.bashrc`
```bash
export KUBE_X_CLUSTERS_PATH=~/kube-x/clusters
```
Create your clusters directory
```bash
mkdir -p "$KUBE_X_CLUSTERS_PATH"
```

### Create your cluster

#### Create a cluster directory

Create a `cluster directory`
```bash
export KUBE_X_DEFAULT_CLUSTER_NAME=my-cluster
mkdir -p "$KUBE_X_CLUSTERS_PATH/$KUBE_X_DEFAULT_CLUSTER_NAME"
```

#### Create the default values files

```bash
kube-x-helm-x values > "$MY_CLUSTER_PATH/values.yaml" 
```

#### Create your environment

Environment variables are set up in `.envrc`

```bash
touch "$KUBE_X_CLUSTERS_PATH/$KUBE_X_DEFAULT_CLUSTER_NAME/.envrc"
```

They contain environment variables used in:
* [Ansible Inventory](../../ansible/inventory.yml)
* [Cluster Values File](values.yaml) for Helm and Jsonnet configuration. 

You can see an example at [.envrc](.envrc)

## Provision the cluster

### Check the Ansible Inventory

Check that the ansible inventory is valid
```bash
kube-x-cluster --cluster "$KUBE_X_DEFAULT_CLUSTER_NAME" inventory
```

### Execute the provisioning

```bash
kube-x-cluster --cluster "$KUBE_X_DEFAULT_CLUSTER_NAME" play
```

## Install applications in the clusters

### Individually

With `helm-x`, you can install any `helm-x` charts.

Example:
* Install Traefik
```bash
kube-x-helm-x --cluster "$KUBE_X_DEFAULT_CLUSTER_NAME" install traefik
```
* Install Cert Manager
```bash
kube-x-helm-x --cluster "$KUBE_X_DEFAULT_CLUSTER_NAME" install cert-manager
```

The whole list of available chats can be seen in the [Charts directory](../../charts/README.md).
