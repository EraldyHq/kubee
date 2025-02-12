# Kubee Helmet Chart

A `Kubee Helmet Chart`:
* is a Chart
    * that installs only one application
    * with the name of the app installed (ie grafana, not grafana operator)
    * that depends on:
        * the [kubee Chart](../../resources/charts/kubee/README.md) to share cluster and installation wide
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

# What is the Kubee Chart?

The [kubee Chart](../../resources/charts/kubee/README.md) is a shared chart dependency with:
* a [shared library](../../resources/charts/kubee/templates/_helpers.tpl)
* a [values.yaml](../../resources/charts/kubee/values.yaml)

The values files has one top node for each [kubee chart](#what-is-a-kubee-chart).
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


## FAQ: Why not multiple sub-chart by umbrella chart?

SubChart cannot by default be installed in another namespace than the umbrella chart.
This is a [known issue with helm and subcharts](https://github.com/helm/helm/issues/5358)

That's why:
* the unit of execution is one sub-chart by umbrella chart
* `kubee` is a common sub-chart of all umbrella chart


## Dev: Cross dependency

Cross Dependency are only used to share values.

When developing a Chart, you should:
* add them in `Chart.yml` and disable them with a condition
```yaml
- name: kubee-traefik-forward-auth
  version: 0.0.1
  alias: traefik_forward_auth
  condition: kubee_internal.install_cross_dependency
```
* add them as symlink
* add the cross-dependency sub-charts directory in the `helmignore` file to avoid symlink recursion

Example: The chart `kubee-dex` depends on the `kubee-traefik-forward-auth` that depends on the `kubee-dex` chart
creating a recursion.

To avoid this recursion, add the `kubee-traefik-forward-auth/charts` in the `helmignore` file
```ignore
charts/kubee-traefik-forward-auth/charts
```