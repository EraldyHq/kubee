# KUBECONFIG 

`kubee` will generate a kube config file dynamically if
* the `KUBECONFIG` env is not set 
* no default config file is found at `~/.kube/config`
* the command `pass` is found


## How

It retrieves:
* the `cluster` data from the `pass` secret manager.
* the `user` data from the `pass` secret manager.
* the `namespace` in this order:
  * command line option
  * `KUBEE_CHART_NAMESPACE`
  * `KUBEE_CONNECTION_NAMESPACE`
  * otherwise `default`

It's a `zero-trust` connection tool.

## Env

* `KUBEE_CLUSTER_NAME`: The cluster to connect (default to `default`)
* `KUBEE_CLUSTER_SERVER_01_IP`: the server ip used by default
* `KUBEE_USER_NAME`: The user to connect with (default to `default`)
* `KUBEE_PASS_HOME`: The directory where to store `kubee` pass information (default to `kubee`)
* `KUBEE_CONNECTION_NAMESPACE`: the connection namespace (default to the app namespace or to the KUBEE_DEFAULT_NAMESPACE)
* `KUBEE_CHART_NAMESPACE`: the chart namespace found in the chart values file.

## How to create the secrets in path

 ```bash
 # Set the config where to extract the information
 export KUBECONFIG="$HOME/.kube/config"
 # The pass home directory (default to kubee)
 export KUBEE_PASS_HOME="kubee"

 # Get the cluster and user name from the KUBECONFIG
 # or set your own
 KUBEE_CLUSTER_NAME=$(kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].name}')
 KUBEE_USER_NAME=$(kubectl config view --minify --raw --output 'jsonpath={$.users[0].name}')

 # Store the user and cluster properties in path
 kubectl config view --minify --raw --output 'jsonpath={$.users[0].client-certificate-data}' | pass insert -m "$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-certificate-data"
 kubectl config view --minify --raw --output 'jsonpath={$.users[0].client-key-data}' | pass insert -m "$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-key-data"
 kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].certificate-authority-data}' | pass insert -m "$KUBEE_PASS_HOME/clusters/$KUBEE_CLUSTER_NAME/certificate-authority-data"
 # The server URI is derived from KUBEE_CLUSTER_SERVER_01_IP
 ```
## How to see the generated config file

```bash
kubee-kubectl config view
```
