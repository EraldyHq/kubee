# # @name

## Overview

Print the environment for the app
such as kubeconfig and app name
used with direnv
Usage: `eval "$(kube-app-env app-name)"`



## Help


A direnv extension to set the environment of an Kubernetes Kustomize App

To avoid executing app in a bad namespace, you would use
this direnv extension to set the app environment.

Executing:
```bash
kube-app-env <app name> <app namespace>
```
where
* `app name` is the name of an app directory below `$KUBE_APP_HOME`
* `app namespace` is the kubernetes namespace (default to the `app name` value)

This command will output the export statement of the app environment
that can be used in your `.envrc` (see below). ie
```bash
export KUBECONFIG=xxx
export KUBE_APP_NAME=xxx
export KUBE_APP_NAMESPACE=xxx
export KUBE_APP_DIRECTORY=xxx
```
Prerequisites:
* The `$KUBE_APP_HOME` environment variable should be set to a directory that
  contains kustomize applications

Usage with `dirvenv`: 
In your `.envrc` of your Kustomize Kubernetes App
```bash
eval (kube-app-env <app name> <app namespace>)
```
