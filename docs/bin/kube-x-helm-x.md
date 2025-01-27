% kube-x-helm-x(1) Version Latest | Helm with Extra's
# NAME

`kube-x-helm-x` (aka `helx`) is the `kube-x` package manager.


# Features

## Familiar

It's based on the following well-supported Kubernetes tools.
* [Helm](https://helm.sh/), the Kubernetes Package Manager
* [Kustomize](https://github.com/kubernetes-sigs/kustomize), the official manifest customization tool 
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
    * the [kube-x Chart](../../resources/charts/kube-x/README.md) to share cluster and installation wide
      * `values.yaml` file 
      * and `library` 
    * and optionally: 
      * cross dependency Charts:
        * to bring cross values to create cross conditional expression. Example:
          * conditional: `if cert_manager.enabled then create_certificate_request`
          * cross: `if prometheus.enabled then create_grafana_data_source with promtheus.name`
        * with a mandatory false condition `kube_x_internal.dont_install_dependency: false`
      * direct/wrapped dependency Chart (for instance, `kube-x-external-secrets` wraps the `external-secret` Chart)
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

> [!Info]
> The `enabled` property comes from the [Helm best practices](https://helm.sh/docs/chart_best_practices/dependencies/#conditions-and-tags)

# What is a Jsonnet Kube-X Chart?

A `Jsonnet Kube-x chart` is a chart that has only a [Jsonnet project](kube-x-helm-post-renderer.md#jsonnet).

It could be then:
* executed only with `Jsonnet`. Example:
```bash
cd jsonnet
rm -rf out && mkdir -p out && jsonnet -J vendor \
  --multi out \
  "main.jsonnet"  \
  --ext-code "values={ kube_x: std.parseYaml(importstr \"../../cluster/values.yaml\") }" \
  | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
```
* or added as Jsonnet dependency

You can then add them in GitOps Pull app such as [ArgoCd](https://argo-cd.readthedocs.io/en/stable/user-guide/jsonnet/)
to manage your infrastructure.

# What is the format of a Cluster Values file?

Rules:
* Hard: Every root property in a cluster values file is the alias name of the chart in `snake_case`.
* Soft: Every property name should be written in `snake_case` 
  * Why? `hyphen-case` is not supported by Helm Template (ie Go template)
  * Why Not in `CamelCase`? So that we get used to the fact that we don't use `-` as a separator

Example:
```yaml
chart_1:
  hostname: foo.bar
  issuer_name: julia
chart_2:
  hostname: bar.foo
  dns_zones: []
```

Helx will transform it in a compliant Helm values.

You can see the Helm values:
* to be applied with:
```bash
helx values --cluster clusterName chartName
```
* applied with:
```bash
helm get -n prometheus values prometheus
```

# Note
## Secret Security

With Helm, you retrieve the applied data (manifests, values) from a storage backend.

The default storage backend for Helm is a `Kubernetes secret`, 
therefore the security is by default managed by Kubernetes RBAC.

Example:
With this command, if you have access to the Kubernetes secret, 
you should be able to see the applied values files with eventually your secrets.
```bash
helm get -n namespace values chartReleaseName
```

More information can be found in the [storage backend section](https://helm.sh/docs/topics/advanced/#configmap-storage-backend)

