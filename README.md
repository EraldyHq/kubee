# Kubee - Kubernetes, the Easy Way 

A One-Clik, Single VPS, Self-Hosted Kubernetes Platform


`E` stands for:
* Easy
* Express
* Extra
* Extensible

## Extras

### Vault

Init a vault after installation with [kubee-vault-init](docs/bin-generated/kubee-vault-init-unseal.md)

### PromTool

Validate and test PrometheusRules with [kubee-promtool](docs/bin-generated/kubee-promtool.md)

### Alert Manager

Query and send alert to the Prometheus Alert Manager with [kubee-alertmanager](docs/bin-generated/kubee-alertmanager.md)

### Xshell

* [Xshell](docs/bin-generated/kubectl-xshell.md) - get a shell from a busybox container or a pod

### Ephemere KubeConfig stored in pass

Generate a Ephemere Kubeconfig from pass with [kubee-config](docs/lib/kubee-config.md)

## List and documentation

* [xshell](docs/bin-generated/kubectl-xshell.md) - get a shell from a busybox container or a pod
* [xapply](docs/bin/kubectl-xapply) - apply a kustomize app (ie `kustomize apply`)
* [kubee-env](docs/bin/kubee-env) - print the environment configuration of an app 
* [kubee-events](docs/bin/kubectl-xevent) - shows the events of an app
* [kubee-file-explorer](docs/bin/kubectl-xvolume-explorer) - Explore the files of an app via SCP/SFTP
* [kubectl-xlogs](docs/bin/kubee-logs) - print the logs of pods by app name
* [kubectl-xpods](docs/bin/kubectl-xpod) - watch/list the pods of an app
* [kubectl-xrestart](docs/bin/kubectl-xrestart) - execute a rollout restart
* [kubeetop](docs/bin/kubectl-xtop) - shows the top processes of an app
* [kubeecert](docs/bin-generated/kubectl-xcert.md) - print the kubeconfig cert in plain text
* [kube-cidr](docs/bin/kubee-pods-cidr) - print the cidr by pods
* [kube-k3s](docs/bin/kubee-pods-cidr) - collection of k3s utilities
* [kube-memory](docs/bin/kubee-memory) - print the cpu and memory used by pods
* [kube-ns-current](docs/bin/kubectl-xns) - set or show the current namespace
* [kube-ns-events](docs/bin/kubectl-xevents) - show the event of a namespace
* [kube-pods-ip](docs/bin/kubee-pods-ip) - show the ip of pods
* [kube-pvc-move](docs/bin/kubee-pvc-move) - move a pvc (Automation not finished)



## Installation

* Mac / Linux / Windows WSL with HomeBrew
```bash
brew install --HEAD gerardnico/tap/kubee
```

## What is an app name?

In all `app` scripts, you need to give an `app name` as argument.

The scripts will try to find resources for an app:
* via the `app.kubernetes.io/name=$APP_NAME` label
* or via the `.envrc` of an app directory

Problem: We need multiple apps in the same directory
because an operator may ship multiple CRD definitions.

See: app.kubernetes.io/part-of: argocd

Example: the Prometheus Operator
* prometheus (Prometheus CRD)
* alertmanager (AlertManager CRD)
* pushgateway
* node exporter


### What is Envrc App Definition?

In this configuration:
* All apps are in a subdirectory of the `KUBEE_APP_HOME` directory (given by the `$KUBEE_APP_HOME` environment variable).
* The name of an app is the name of a subdirectory
* Each app expects a `kubeconfig` file located at `~/.kube/config-<app name>` with the default context set with the same app namespace
* Each app directory have a `.envrc` that:
  * is run by `direnv` 
  * sets the app environment via the [kubee-env](docs/bin/kubee-env) script
```bash
# kubee-env` is a direnv extension that set the name, namespace, kubeconfig and directory of an app as environment
# so that you don't execute an app in a bad namespace, context ever. 
eval "$(kubee-env appName [namespaceName])"
```



## Contribute 

See [Contribute/Dev](contrib/contribute.md)

## Kubectl Plugins

To make these utilities [Kubectl plugin](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/), 
you can rename them from `kubee-` to `kubectl-`

They should then show up in:
```bash
kubectl plugin list
```


You can discover other plugins at [Krew](https://krew.sigs.k8s.io/plugins/)
