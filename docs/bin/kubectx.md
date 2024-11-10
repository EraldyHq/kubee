
# NAME

`kubectx` is a `kubectl` wrapper that creates a `kubeconfig` from environment variable.

## ENV

* `KUBE_X_CLUSTER_CERTIFICATE_AUTHORITY_DATA`: The cluster certificate authority


It still exposes


## Pass create

```bash
KUBE_X_USER=default
KUBE_X_HOME=kube-x
export KUBECONFIG=$HOME/.kube/config
kubectl config view --minify --raw --output 'jsonpath={..user.client-certificate-data}' | pass insert -m "$KUBE_X_HOME/users/$KUBE_X_USER/client-certificate-data"
kubectl config view --minify --raw --output 'jsonpath={..user.client-key-data}' | pass insert -m "$KUBE_X_HOME/users/$KUBE_X_USER/client-key-data"
```

