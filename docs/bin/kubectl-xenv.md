% kubectl-xenv(1) Version Latest | Print the export environment variables
# DESCRIPTION

Print the export environment statements.

# USAGE AND EXAMPLE

This script is used by all `kube-x` scripts to set the [environment](#ENVIRONMENT)

```bash
KUBE_X_ENV=$(source kubectl-xenv "$KUBE_X_APP_NAME")
eval "$KUBE_X_ENV"
```

Note: The substitution is not in the eval because bash would not stop the script otherwise
even with the `-Ee` options.

# SYNOPSIS

${SYNOPSIS}


# ENVIRONMENT



## KUBE_X_APP_NAME

```bash
export KUBE_X_APP_NAME=xxx
```  
Default to the current directory name if it is below the [KUBE_X_APP_HOME](#KUBE_X_APP_HOME)

The kubernetes objects are searched with the label `app.kubernetes.io/name=<app name>`


## KUBE_X_APP_NAMESPACE

The `KUBE_X_APP_NAMESPACE` environment variable defines the `namespace` of the app
and is used to determine the [connection namespace](#namespace-order-of-precedence) 

## KUBE_X_DEFAULT_NAMESPACE

`KUBE_X_DEFAULT_NAMESPACE` defines the default [connection namespace](#namespace-order-of-precedence)
when no [namespace has been found](#namespace-order-of-precedence)


## KUBE_X_APP_HOME

The `$KUBE_X_APP_HOME` environment variable defines a path environment variable where each path is a directory that contains 
namespace applications.

It should be set in your `.bashrc`

Example:
```bash
export KUBE_X_APP_HOME=$HOME/my-kube-apps:$HOME/my-other-kube-apps
```

## KUBE_X_BUSYBOX_IMAGE

The image used by [kubectl-xshell](kubectl-xshell.md) when asking for a shell in a busybox.

Default to [ghcr.io/gerardnico/busybox:latest](https://github.com/gerardnico/busybox/pkgs/container/busybox)

```bash
export KUBE_X_BUSYBOX_IMAGE=ghcr.io/gerardnico/busybox:latest
```

## Connection Namespace

The connection namespace is a derived environment variable `KUBE_X_CONNECTION_NAMESPACE` used by [kubectx](kube-x-kubectl).

### Namespace Order of precedence


In order, the connection namespace value used is:
* `default` if the flag `--all-namespace` is passed
* the option value of the flag `-n|--namespace`
* [KUBE_X_APP_NAMESPACE](#KUBE_X_APP_NAME)
* [KUBE_X_APP_NAME](#KUBE_X_APP_NAME) if set
* [KUBE_X_DEFAULT_NAMESPACE](#KUBE_X_APP_NAME) if it exists
* Otherwise, for the [KUBE_X_KUBECTL](#KUBE_X_KUBECTL) value of:
    * `kubectx`: `default`
    * `kubectl`: the `kubeconfig` current namespace value

### Mandatory Namespace

The namespace is only mandatory for the [kubectl-xapply](kubectl-xapply.md)
command.

Otherwise, it's determined by a label global search on the app name. 

## How

### How to set my own environment variable by app scope

You can override the default environment values by creating a `.envrc` located
in the app directory (ie `KUBE_X_APP_HOME/KUBE_X_APP_NAME`).


# TIP

To get the env in the prompt such as cluster and namespace, check [kube-ps1](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kube-ps1)
