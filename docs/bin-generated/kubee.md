# Kube Easy - A One-Clik, Single VPS, Self-Hosted Kubernetes Platform


## About
`kubee` is the main entry of the `kubee platform`


## SYNOPSIS

```bash
kubee [kubee options] command args
```

where:

* `command` is one of:
  * `cluster`                  : Kubernetes cluster hosts installation and configuration
  * `chart`                    : Kubee Package Manager
  * `app`                      : Application scoped commands
  * `kubectl`                  : Kubectl Kubee scluster aware

* `kubee options` are:
  * `-n|--namespace name`    : the `connection namespace name` default to `KUBEE_CONNECTION_NAMESPACE`, ultimately to `default`.
  * `-c|--cluster   name`    : the `cluster name` default to `KUBEE_CLUSTER_NAME`.
  * `--debug`                : Print debug statements.
  * `--print-commands`       : Print the command statements.


Example:
* Execute the kubectl `cluster-info` command against the cluster
```bash
kubee -c my-kubee kubectl cluster-info
```

## Extras

### Vault

Init a vault after installation with [kubee-vault-init](../bin-generated/kubee-vault-init-unseal.md)

### PromTool

Validate and test PrometheusRules with [kubee-promtool](../bin-generated/kubee-promtool.md)

### Alert Manager

Query and send alert to the Prometheus Alert Manager with [kubee-alertmanager](../bin-generated/kubee-alertmanager.md)

### Shell

* [Kubee shell](../bin-generated/kubee-shell.md) - get a shell from a busybox container or a pod

### Ephemere KubeConfig stored in pass

Generate a Ephemere Kubeconfig from pass with [kubee-config](../lib/kubee-config.md)

## List and documentation

* [kubee helmet](../bin-generated/kubee-chart.md) - the kubee chart manager
* [kubee shell](../bin-generated/kubee-shell.md) - get a shell from a busybox container or a pod
* [kubee-kapply](../bin/kubee-kapply) - apply a kustomize app (ie `kustomize apply`)
* [kubee-env](../bin/kubee-env) - print the environment configuration of an app
* [kubee-events](../bin/kubee-event) - shows the events of an app
* [kubee-file-explorer](../bin/kubee-volume-explorer) - Explore the files of an app via SCP/SFTP
* [kubee-logs](../bin/kubee-logs) - print the logs of pods by app name
* [kubee-pods](../bin/kubectl-xpod) - watch/list the pods of an app
* [kubee-restart](../bin/kubee-restart) - execute a rollout restart
* [kubee top](../bin/kubectl-xtop) - shows the top processes of an app
* [kubee cert](../bin-generated/kubee-cert.md) - print the kubeconfig cert in plain text
* [kubee-cidr](../bin/kubee-pods-cidr) - print the cidr by pods
* [kubee-k3s](../bin/kubee-k3s.md) - collection of k3s utilities
* [kube-ns-current](../bin/kubee-ns) - set or show the current namespace
* [kube-ns-events](../bin/kubectl-xevents) - show the event of a namespace
* [kube-pods-ip](../bin/kubee-pods-ip) - show the ip of pods
* [kube-pvc-move](../bin/kubee-pvc-move) - move a pvc (Automation not finished)

## What is an app name?

In all `app` scripts, you need to give an `app name` as argument.

The scripts will try to find resources for an app:
* via the `app.kubernetes.io/instance=$APP_NAME` label
* via the `app.kubernetes.io/name=$APP_NAME` label
* or via the `.envrc` of an app directory

Problem: We need multiple apps in the same directory
because an operator may ship multiple CRD definitions.

See: `app.kubernetes.io/part-of: argocd`

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


## Kubectl Plugins

To make these utilities [Kubectl plugin](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/),
you can rename them from `kubee-` to `kubectl-`

They should then show up in:
```bash
kubectl plugin list
```


You can discover other plugins at [Krew](https://krew.sigs.k8s.io/plugins/)
