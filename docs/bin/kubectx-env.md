% kubectx-env(1) Version Latest | Return client kubernetes credential from pass
# NAME

`kubectx-env` returns the client kubernetes credential from pass

# ENVIRONMENT VARIABLES

* `KUBEE_USER`: the username (default to `default`)
* `KUBEE_CLUSTER`: the cluster name (default to `default`)


# DERIVED

* `KUBEE_CONNECTION_NAMESPACE`: the connection namespace. See [how the namespace is determined](kubee-env.md#namespace-order-of-precedence)
* `KUBEE_CONTEXT_NAME`: the context name in the config file. Derived as `$KUBEE_USER@$KUBEE_CLUSTER/$KUBEE_APP_NAMESPACE`
* `KUBEE_PASS_HOME`: the home directory in pass

# Location of secret

* `client-certificate-data` : `$KUBEE_PASS_HOME/users/$KUBEE_USER/client-certificate-data`
* `client-key-data` : `$KUBEE_PASS_HOME/users/$KUBEE_USER/client-key-data`
* `client-token` : `$KUBEE_PASS_HOME/users/$KUBEE_USER/client-token`


