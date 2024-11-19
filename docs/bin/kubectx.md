% kubectx(1) Version Latest | kubectl with kubeconfig information stored in pass
# NAME

`kubectx` is a `kubectl` wrapper that gets the `kubeconfig` information from the `pass` secret manager.

## ENV

* `KUBE_X_CLUSTER`: The cluster to connect (default to `default`)
* `KUBE_X_USER`: The user to connect with (default to `default`)
* `KUBE_X_PASS_HOME`: The directory where to store `kube-x` pass information (default to `kube-x`)


## How to create the secret in path

```bash
# Set the config where to extract the information
export KUBECONFIG="$HOME/.kube/config"
# The pass home directory (default to kube-x)
export KUBE_X_PASS_HOME="kube-x"

# Get the cluster and user name from the KUBECONFIG
# or set your own  
KUBE_X_CLUSTER=$(kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].name}')
KUBE_X_USER=$(kubectl config view --minify --raw --output 'jsonpath={$.users[0].name}')

# Store the user and cluster properties in path
kubectl config view --minify --raw --output 'jsonpath={$.users[0].client-certificate-data}' | pass insert -m "$KUBE_X_PASS_HOME/users/$KUBE_X_USER/client-certificate-data"
kubectl config view --minify --raw --output 'jsonpath={$.users[0].client-key-data}' | pass insert -m "$KUBE_X_PASS_HOME/users/$KUBE_X_USER/client-key-data"
kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].certificate-authority-data}' | pass insert -m "$KUBE_X_PASS_HOME/clusters/$KUBE_X_CLUSTER/certificate-authority-data"
kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].server}' | pass insert -m "$KUBE_X_PASS_HOME/clusters/$KUBE_X_CLUSTER/server"
```

## Other kubectl replacement project

* [fubectl: fuzzy kubectl](https://github.com/kubermatic/fubectl)
* [kubie](https://github.com/sbstp/kubie)
* [kubectx/kubens](https://github.com/ahmetb/kubectx)


