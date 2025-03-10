# Kubectl


[Kubectl](https://kubernetes.io/docs/reference/kubectl/) is the built-in cli of Kubernetes.


## Features
### Cluster aware

With `kubee kubectl`, `kubectl` becomes cluster aware and 
makes sure to creates a connection to the [cluster](cluster.md)

### Oidc

We support [oidc login](oidc.md) with the [kubellogin oidc plugin](https://github.com/int128/kubelogin)
when the `dex` is enabled.
