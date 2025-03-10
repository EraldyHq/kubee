# Kubee Helmet Chart


A `Kubee Chart` is a helm chart that supports:
* the following templating tools:
  * a [Jsonnet](jsonnet-chart.md)
  * a [Kustomize](kustomize-project.md)
* a [cluster values file](cluster-values.md)
* [CRDs chart](crds-chart.md) as dependencies

They are installed with `kubee helmet`.


## Definition

A `Kubee Helmet Chart`:
* is a Chart
    * that installs only one application
    * with the name of the app installed (ie grafana, not grafana operator)
    * that depends on:
        * the [kubee Cluster Library Chart](../../charts/cluster/README.md) to share cluster and installation wide
            * `values.yaml` file
            * and `library`
        * and optionally:
            * cross dependency Charts:
                * to bring cross values to create cross conditional expression. Example:
                    * conditional: `if cert_manager.enabled then create_certificate_request`
                    * cross: `if prometheus.enabled then create_grafana_data_source with promtheus.name`
                * with a mandatory false condition `kubee_internal.dont_install_dependency: false`
            * direct/wrapped dependency Chart (for instance, `kubee-external-secrets` wraps the `external-secret` Chart)
    * with optional:
      * [Jsonnet](jsonnet-project.md) 
      * or [kustomize](kustomize-project.md)

* installs only one application as `kubee` is a platform.
    * For instance, installing an application such as grafana can be done via:
        * a raw deployment manifest
        * or the grafana operator
    * Only one chart is going to supports this 2 methods.

    
## Values file

Each `values.yaml` file should contain at least the following properties:
* `namespace = name`: the namespace where to install the chart
* `enabled = false`: if the chart is used or not. The value should be false. It's used to:
    * conditionally applied manifest. If there is no grafana, don't install the dashboard
    * cluster bootstrapping (ie install all charts at once)

> [!Info]
> The `enabled` property comes from the [Helm best practices](https://helm.sh/docs/chart_best_practices/dependencies/#conditions-and-tags)

The values file should contain different nodes for:
* the chart itself
* the external services (opsgenie, new relic, grafana cloud, ...) - making clear what the parameters are for.

## Kind


* a [app charts](app-chart.md) - a chart that installs an application
* a [CRD charts](crds-chart.md) - a chart that installs CRDS
* a [Cluster Chart](cluster-chart.md) - a chart that drives the installation of kubernetes
