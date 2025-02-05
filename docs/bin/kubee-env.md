% kubee-env(1) Version Latest | Print the export environment variables
# DESCRIPTION

Print the export environment statements.

# USAGE AND EXAMPLE

This script is used by all `kubee` scripts to set the [environment](#ENVIRONMENT)

```bash
KUBEE_ENV=$(source kubee-env "$KUBEE_APP_NAME")
eval "$KUBEE_ENV"
```

Note: The substitution is not in the eval because bash would not stop the script otherwise
even with the `-Ee` options.

# SYNOPSIS

${SYNOPSIS}


# ENVIRONMENT



## KUBEE_USER_NAME

`KUBEE_USER_NAME`: the connection username (default to `default`)
Used in the creation of a config file

## KUBEE_CLUSTER_NAME

`KUBEE_CLUSTER_NAME` defines the default cluster name.
You can set it also via the `-c` or `--cluster` command line option.

The cluster name is used:
* in connection
* in the detection of a cluster project

## KUBEE_CLUSTERS_PATH
`KUBEE_CLUSTERS_PATH` defines a list of directory path where you could find cluster definitions (environment, values and inventory file)

Example
```bash
export KUBEE_CLUSTERS_PATH="$HOME/argocd/clusters:$HOME/argocd-2/clusters"
```

## KUBEE_CHARTS_PATH

The `$KUBEE_CHARTS_PATH` environment variable defines a path environment variable where each path is a directory that contains 
kubee charts.

It should be set in your `.bashrc`

Example:
```bash
export KUBEE_CHARTS_PATH=$HOME/my-kubee-charts:$HOME/my-other-kubee-charts
```

## KUBEE_BUSYBOX_IMAGE

The image used by [kubee-shell](kubee-shell) when asking for a shell in a busybox.

Default to [ghcr.io/gerardnico/busybox:latest](https://github.com/gerardnico/busybox/pkgs/container/busybox)

```bash
export KUBEE_BUSYBOX_IMAGE=ghcr.io/gerardnico/busybox:latest
```


## KUBEE_CONNECTION_NAMESPACE_DEFAULT
`KUBEE_CONNECTION_NAMESPACE_DEFAULT`: the default connection namespace.

## KUBEE_PASS_HOME

`KUBEE_PASS_HOME`: the home directory in pass (default to `kubee`) for the location of the [connection secrets](#connection-secrets-path)


# TIP

To get the env in the prompt such as cluster and namespace, check [kube-ps1](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kube-ps1)


# Connection

## Connection namespace

Connection Namespace Order of precedence:
In order, the connection namespace value used is:
* `default` if the flag `--all-namespace` is passed
* the option value of the flag `-n|--namespace`
* [KUBEE_CONNECTION_NAMESPACE_DEFAULT](#kubee_connection_namespace_default) if it exists
* otherwise `default`


## Connection Context Name 
The connection context name in the config file is derived as `$KUBEE_USER@$KUBEE_CLUSTER/$KUBEE_CONNECTION_NAMESPACE`

## Connection Secrets Path

* `client-certificate-data` : `$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-certificate-data`
* `client-key-data` : `$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-key-data`
* `client-token` : `$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-token`


