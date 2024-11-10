# Kube X- A Library of Kubernetes Utilities eXtension


## About

A library of Kubernetes Utilities eXtension


## List and documentation


* [kube-x-apply](docs/bin/kube-x-apply) - apply a kustomize app (ie `kustomize apply`)
* [kube-x-shell](docs/bin/kube-x-shell) - get a shell into an app or your cluster
* [kube-x-env](docs/bin/kube-x-env.md) - print the environment configuration of an app 
* [kube-x-events](docs/bin/kube-x-events.md) - shows the events of an app
* [kube-x-file-explorer](docs/bin/kube-x-file-explorer.md) - Explore the files of an app via SCP/SFTP
* [kube-x-logs](docs/bin/kube-x-logs.md) - print the logs of pods by app name
* [kube-x-pods](docs/bin/kube-x-pods.md) - watch/list the pods of an app
* [kube-x-restart](docs/bin/kube-x-restart.md) - execute a rollout restart
* [kube-x-top](docs/bin/kube-x-top.md) - shows the top processes of an app
* [kube-cert](docs/bin/kube-x-cert) - print the kubeconfig cert in plain text
* [kube-cidr](docs/bin/kube-x-cidr) - print the cidr by pods
* [kube-k3s](docs/bin/kube-x-cidr) - collection of k3s utilities
* [kube-memory](docs/bin/kube-x-memory) - print the cpu and memory used by pods
* [kube-ns-current](docs/bin/kube-x-ns-current) - set or show the current namespace
* [kube-ns-events](docs/bin/kube-x-ns-events) - show the event of a namespace
* [kube-pods-ip](docs/bin/kube-x-pods-ip) - show the ip of pods
* [kube-pvc-move](docs/bin/kube-x-pvc-move) - move a pvc (Automation not finished)



## Installation

* Mac / Linux / Windows WSL with HomeBrew
```bash
brew install --HEAD gerardnico/tap/kube
# Add the libraries directory into your path in your `.bashrc` file
export PATH=$(brew --prefix bashlib)/lib:$PATH
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
  * sets the app environment via the [kube-x-env](docs/bin/kube-x-env.md) script
```bash
# kube-x-env` is a direnv extension that set the name, namespace, kubeconfig and directory of an app as environment
# so that you don't execute an app in a bad namespace, context ever. 
eval "$(kube-x-env appName [namespaceName])"
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
