% kube-x-helm-x(1) Version Latest | Helm with Extra's
# NAME

`kube-x-helm-x` (aka `helx`) is the `kube-x` package manager.


# Features

## Familiar

It's based on the following well-supported Kubernetes tools.
* [Helm](https://helm.sh/), the Kubernetes Package Manager
* [kustomize](https://github.com/kubernetes-sigs/kustomize), the official manifest customization tool 
* [Jsonnet Kubernetes](https://jsonnet.org/articles/kubernetes.html), the Google configuration language

At its core, `helx` is a `Helm` wrapper.

It just executes [Helm commands](https://helm.sh/docs/helm/helm/) and therefore installs [Charts](https://helm.sh/docs/topics/charts/)

All new installations:
* have a [history (ie revision)](https://helm.sh/docs/helm/helm_history/)
* can be [rollback](https://helm.sh/docs/helm/helm_rollback/)
* can be [diffed](https://github.com/databus23/helm-diff)

There is no magic. All commands are:
* bash command, 
* printed to the shell (visible)
* and can be re-executed at wil

## New

`Helx` adds support for:
* `Jsonnet` - to add [Prometheus Mixin](https://monitoring.mixins.dev/)) support
* `kustomize` - to add support for application without Helm Chart such as ArgoCd)
* cluster based installation through the use of the [kube-x library chart](../../resources/charts/kube-x/) the same values are used accros multiple app/charts
  * with environment variables processing
  * with configurable namespace


# Synopsis

${SYNOPSIS}


# What is a Kube-x Chart?

A `Kube-x Chart` is:
* a [sub-chart](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/) that depends on:
  * the [kube-x Chart](../../resources/charts/kube-x/README.md)
  * and optionally a application Chart
* with optional `Jsonnet` and `kustomize` processing through [the kube-x helm post-renderer](kube-x-helm-post-renderer.md)

