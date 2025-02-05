# SSH Cluster

## About

This directory contains an example of an SSH cluster. 

## Steps

### Create your clusters directory

A `clusters directory` is a directory that contains one or more cluster directory.

In your `.bashrc`
```bash
export KUBEE_CLUSTERS_PATH=~/kubee/clusters
```
Create your clusters directory
```bash
mkdir -p "$KUBEE_CLUSTERS_PATH"
```

### Create your cluster

#### Create a cluster directory

Create a `cluster directory`
```bash
KUBEE_CLUSTER_NAME=my-cluster
mkdir -p "$KUBEE_CLUSTERS_PATH/$KUBEE_CLUSTER_NAME"
```

#### Create the default values files

```bash
kubee-chart values > "$MY_CLUSTER_PATH/values.yaml" 
```

#### Create your environment

Environment variables are set up in `.envrc`

```bash
touch "$KUBEE_CLUSTERS_PATH/$KUBEE_CLUSTER_NAME/.envrc"
```

They contain environment variables used in:
* [Ansible Inventory](../../ansible/inventory.yml)
* [Cluster Values File](values.yaml) for Helm and Jsonnet configuration. 

You can see an example at [.envrc](.envrc)

## Provision the cluster

### Check the Ansible Inventory

Check that the ansible inventory is valid
```bash
kubee-cluster --cluster "$KUBEE_CLUSTER_NAME" inventory
```

### Execute the provisioning

```bash
kubee-cluster --cluster "$KUBEE_CLUSTER_NAME" play
```

## Install Applications in the clusters

### Individually

With `kubee chart`, you can install any `kubee charts`.

Example:
* Install Traefik
```bash
kubee-chart --cluster "$KUBEE_CLUSTER_NAME" install traefik
```
* Install Cert Manager
```bash
kubee-chart --cluster "$KUBEE_CLUSTER_NAME" install cert-manager
```

The whole list of available `kubee charts` can be seen in the [Kubee Charts directory](../../charts/README.md).
