% kubectl-xenv(1) Version Latest | Print the export environment variables
# DESCRIPTION

Print the export environment statements.

# USAGE AND EXAMPLE

This script is used by all `kube-x` scripts to set the [environment](#ENVIRONMENT)

```bash
eval $(kubectl-xenv $APP_NAME)
```

# SYNOPSIS

${SYNOPSIS}


# ENVIRONMENT

You can override the default environment values by creating a `.envrc` located
in the app directory (ie `KUBE_X_APP_HOME/KUBE_X_APP_NAME`).


## KUBE_X_APP_NAME

```bash
export KUBE_X_APP_NAME=xxx
```  
* Default to the current directory name if it is below the [KUBE_X_APP_HOME](#KUBE_X_APP_HOME)
* Mandatory Otherwise

## KUBE_X_APP_HOME

The `$KUBE_X_APP_HOME` environment variable defines a directory that contains applications.

It should be set in your `.bashrc`

## KUBE_X_NAMESPACE

The `KUBE_X_NAMESPACE` environment variable defines the `namespace`.

* Default to [KUBE_X_APP_NAME](#KUBE_X_APP_NAME) if it exists
* Otherwise, to the `kubeconfig` current namespace


# TIP

To get the env in the prompt such as cluster and namespace, check [kube-ps1](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kube-ps1)
