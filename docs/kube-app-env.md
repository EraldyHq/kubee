# kube-app-env

## Overview

Print the export environment statement for the app

Used in a direnv setup



## Help


Note: This command is intended to be used in a `.envrc` file executed by `dirvenv`
See the end section

Usage: Print the environment variables of a Kubernetes App
to set them automatically by App directory with direnv

Executing:
```bash
kube-app-env <app name> [<app namespace>]
```
will output:
```bash
export KUBECONFIG=xxx         # value=~/.kube/config-<App Name>
export KUBE_APP_NAME=xxx      # value=App Name
export KUBE_APP_NAMESPACE=xxx # value=App Namespace (Default to App Name if not set)
export KUBE_APP_DIRECTORY=xxx # value=$KUBE_APP_HOME/<App Name>
```

Envrc/Direnv Usage:
In a `.envrc` file executed by `dirvenv`, you would set:
```bash
eval (kube-app-env <app name> <app namespace>)
```
Prerequisites:
* The `$KUBE_APP_HOME` environment variable should be set to a directory that
  contains kustomize applications


To get the cluster and namespace in your prompt, check [kube-ps1](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kube-ps1)
