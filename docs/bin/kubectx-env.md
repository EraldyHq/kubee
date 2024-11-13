% kubectx-env(1) Version Latest | Return client kubernetes credential from pass
# NAME

`kubectx-env` returns the client kubernetes credential from pass

# ENVIRONMENT VARIABLES

* `KUBE_X_USER`: the username (default to `default`)
* `KUBE_X_CLUSTER`: the cluster name (default to `default`)


# DERIVED

* `KUBE_X_CONNECTION_NAMESPACE`: the connection namespace. See [how the namespace is determined](kubectl-xenv.md#namespace-order-of-precedence)
* `KUBE_X_CONTEXT_NAME`: the context name in the config file. Derived as `$KUBE_X_USER@$KUBE_X_CLUSTER/$KUBE_X_APP_NAMESPACE`
* `KUBE_X_PASS_HOME`: the home directory in pass

# Location of secret

* `client-certificate-data` : `$KUBE_X_PASS_HOME/users/$KUBE_X_USER/client-certificate-data`
* `client-key-data` : `$KUBE_X_PASS_HOME/users/$KUBE_X_USER/client-key-data`
* `client-token` : `$KUBE_X_PASS_HOME/users/$KUBE_X_USER/client-token`


