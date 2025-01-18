% kube-x-helm-x(1) Version Latest | Helm with Extra's
# NAME

`kube-x-helm-x` (aka `helx`) is the `kube-x` package manager.


# Features

## Familiar

It's based on the following well-supported Kubernetes tools.
* [Helm](https://helm.sh/), the Kubernetes Package Manager
* [kustomize](https://github.com/kubernetes-sigs/kustomize), the official manifest customization tool 
* [Jsonnet Kubernetes](https://jsonnet.org/articles/kubernetes.html), the Google configuration language

At its core, `helm-x` is a `Helm` wrapper.

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

A `Kube-x Chart`:
* is a [sub-chart](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/)
  * that installed only one application 
  * with the name of the app installed (ie grafana, not grafana operator) 
  * that depends on:
    * the [kube-x Chart](../../resources/charts/kube-x/README.md) to share
      * `values.yaml` file 
      * and `library` 
    * and optionally one other Chart
  * with optional `Jsonnet` and `kustomize` processing through [the kube-x helm post-renderer](kube-x-helm-post-renderer.md)
    
* installs only one application as `kube-x` is a platform. 
  * For instance, installing an application such as grafana can be done via:
    * a raw deployment manifest
    * or the grafana operator
  * Only one chart is going to supports this 2 methods. 

# What is the Kube-x Chart?

The [kube-x Chart](../../resources/charts/kube-x/README.md) is a shared chart dependency with:
* a [shared library](../../resources/charts/kube-x/templates/_helpers.tpl)
* a [values.yaml](../../resources/charts/kube-x/values.yaml)

The values files has one top node for each [kube-x chart](#what-is-a-kube-x-chart).
Each node contains all configurations for:
  * the chart 
  * the external services (opsgenie, new relic, grafana cloud, ...) - making clear what the parameters are for.

Each `values.yaml` top configuration node contains the following common properties:
  * `namespace`: the namespace where to install the chart (default to the name of the chart if not found)
  * `enabled`: if the chart is used or not (default to false if not found). It's used to:
    * conditionally applied manifest. If there is no grafana, don't install the dashboard
    * cluster bootstrapping (ie install all charts at once)


