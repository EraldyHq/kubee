# Kube - A Library of Kubernetes Utilities


## About

A library of Kubernetes Utilities.


## List and documentation


* [kube-app-apply](docs/kube-app-apply.md) - apply a kustomize app (ie `kustomize apply`)
* [kube-app-bash](docs/kube-app-bash.md) - get a shell into an app or your cluster
* [kube-app-env](docs/kube-app-env.md) - print the environment configuration of an app 
* [kube-app-events](docs/kube-app-events.md) - shows the events of an app
* [kube-app-file-explorer](docs/kube-app-file-explorer.md) - Explore the files of an app via SCP/SFTP
* [kube-app-logs](docs/kube-app-logs.md) - print the logs of pods by app name
* [kube-app-pods](docs/kube-app-pods.md) - watch/list the pods of an app
* [kube-app-restart](docs/kube-app-restart.md) - execute a rollout restart
* [kube-app-top](docs/kube-app-top.md) - shows the top processes of an app
* [kube-cert](docs/kube-cert.md) - print the kubeconfig cert in plain text
* [kube-cidr](docs/kube-cidr.md) - print the cidr by pods
* [kube-k3s](docs/kube-cidr.md) - collection of k3s utilities
* [kube-memory](docs/kube-memory.md) - print the cpu and memory used by pods
* [kube-ns-current](docs/kube-ns-current.md) - set or show the current namespace
* [kube-ns-events](docs/kube-ns-events.md) - show the event of a namespace
* [kube-pods-ip](docs/kube-pods-ip.md) - show the ip of pods
* [kube-pvc-move](docs/kube-pvc-move.md) - move a pvc (Automation not finished)



## Installation

* Mac / Linux / Windows WSL with HomeBrew
```bash
brew install --HEAD gerardnico/tap/kube
```

## What is an app name?

In all `app` scripts, you need to give an `app name` as argument.

The scripts will try to find resources for an app:
* via the `app.kubernetes.io/name=$APP_NAME` label
* or via the `.envrc` of an app directory


### What is Envrc App Definition?

In this configuration:
* All apps are in a subdirectory of the `KUBE_APP_HOME` directory (given by the `$KUBE_APP_HOME` environment variable).
* The name of an app is the name of a subdirectory
* Each app expects a `kubeconfig` file located at `~/.kube/config-<app name>` with the default context set with the same app namespace
* Each app directory have a `.envrc` that:
  * is run by `direnv` 
  * sets the app environment via the [kube-app-env](docs/kube-app-env.md) script
```bash
# kube-app-env` is a direnv extension that set the name, namespace, kubeconfig and directory of an app as environment
# so that you don't execute an app in a bad namespace, context ever. 
eval "$(kube-app-env appName [namespaceName])"
```


## Contribute 

See [Contribute/Dev](contribute.md)

## Kubectl Plugins

To make these utilities [Kubectl plugin](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/), 
you can rename them from `kube-` to `kubectl-`

They should then show up in:
```bash
kubectl plugin list
```


You can discover other plugins at [Krew](https://krew.sigs.k8s.io/plugins/)
