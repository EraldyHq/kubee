# Kube - A Library of Kubernetes Utilities


## About

A library of Kubernetes Utilities.


## List

## Kustomize App Utilities

### Direnv App Configuration


* These utilities expect all Kustomize apps to be below the same directory located by `$KUBE_APP_HOME` environment variable.
* The name of an app is the name of a subdirectory that contains a `kustomization.yml` file.
* Each app directory should have a `.envrc` that set the app environment via the [kube-app-env](docs/kube-app-env.md)
```bash
# kube-app-env` is a direnv extension that set the name, namespace, kubeconfig and directory of an app as environment
# so that you don't execute an app in a bad namespace, context ever. 
eval "$(kube-app-env directoryName [namespaceName])"
```
* Each app expects a `kubeconfig` file located at `~/.kube/config-<app name>` with the default context set with the same app namespace

### app.kubernetes.io/name
Utilities will try to find an app via the `app.kubernetes.io/name` label.

`app.kubernetes.io/name=$APP_NAME`

### Usage / Documentation

Once the prerequisites are met, you can run these commands from anywhere with only the `app name` as argument:
* [kube-app-apply](docs/kube-app-apply.md) - to apply an app (ie `kustomize apply`)

## List

* [kube-app-restart](docs/kube-app-restart.md) - to execute a rollout restart
* [kube-bash](docs/kube-bash.md) - to log with bash in a pod by app name
* [kube-cidr](docs/kube-cidr.md) - print the cidr by pods
* [kube-logs](docs/kube-logs.md) - print the log of pods by app name


## Installation

* Mac / Linux with HomeBrew
```bash
brew install --HEAD gerardnico/tap/kube
```


## Contribute 

See [Contribute/Dev](contribute.md)