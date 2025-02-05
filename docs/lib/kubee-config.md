% kubee-config(1) Version Latest | kubee-config
# kubee-config.sh documentation

Return a `KUBECONFIG` file

## DESCRIPTION

If the `KUBECONFIG` env is not set, `kubee` will generate it dynamically.

## How

It retrieves:
* the `cluster` data from the `pass` secret manager.
* the `user` data from the `pass` secret manager.
* the `namespace` from the env

It's a `zero-trust` connection tool.

## ENV

* `KUBEE_CLUSTER`: The cluster to connect (default to `default`)
* `KUBEE_USER`: The user to connect with (default to `default`)
* `KUBEE_PASS_HOME`: The directory where to store `kubee` pass information (default to `kubee`)
* `KUBEE_CONNECTION_NAMESPACE`: the connection namespace (default to the app namespace or to the KUBEE_DEFAULT_NAMESPACE)

## How to create the secrets in path

```bash
# Set the config where to extract the information
export KUBECONFIG="$HOME/.kube/config"
# The pass home directory (default to kubee)
export KUBEE_PASS_HOME="kubee"

# Get the cluster and user name from the KUBECONFIG
# or set your own
KUBEE_CLUSTER=$(kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].name}')
KUBEE_USER=$(kubectl config view --minify --raw --output 'jsonpath={$.users[0].name}')

# Store the user and cluster properties in path
kubectl config view --minify --raw --output 'jsonpath={$.users[0].client-certificate-data}' | pass insert -m "$KUBEE_PASS_HOME/users/$KUBEE_USER/client-certificate-data"
kubectl config view --minify --raw --output 'jsonpath={$.users[0].client-key-data}' | pass insert -m "$KUBEE_PASS_HOME/users/$KUBEE_USER/client-key-data"
kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].certificate-authority-data}' | pass insert -m "$KUBEE_PASS_HOME/clusters/$KUBEE_CLUSTER/certificate-authority-data"
kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].server}' | pass insert -m "$KUBEE_PASS_HOME/clusters/$KUBEE_CLUSTER/server"
```


