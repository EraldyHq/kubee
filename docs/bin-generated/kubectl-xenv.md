# kube-app-env

# DESCRIPTION

Print the export environment statement for the app

Used in a direnv setup



# USAGE


Note: This command is intended to be used in a `.envrc` file executed by `dirvenv`
See the end section

Usage: Print the environment variables of a Kubernetes App
to set them automatically by App directory with direnv

Executing:
```bash
kube-app-env
```

Envrc/Direnv Usage:
In a `.envrc` file executed by `dirvenv`, you would set:
```bash
eval (kube-app-env)
```

To get the cluster and namespace in your prompt, check [kube-ps1](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kube-ps1)

# LIST


## NAMESPACE

```bash
export KUBE_X_NAMESPACE=xxx     
```
The Namespace is defined in order by:
* the `KUBE_X_NAMESPACE` env if set
* the [KUBE_APP_NAME](#KUBE_APP_NAME) if the namespace exists, 
* default ultimately to the config file namespace

# ENV

## KUBE_APP_NAME

```bash
export KUBE_X_APP_NAME=xxx
``` 
Default to the working directory name 

## KUBE_APP_HOME

The `$KUBE_APP_HOME` environment variable should be set to a directory 
that contains applications.

## KUBE_X_NAMESPACE

The `KUBE_X_NAMESPACE` environment variable defines the [namespace](#namespace).



