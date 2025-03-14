# Kubee Helmet Chart Dev

This page contains information for developer that wants to develop [Kubee chart](kubee-helmet-chart.md)
## Kind

### CRDS

Charts that ends up with `crds` are CRDS charts.
These charts are dedicated Helm Chart
that follows the [Helm CRD Method 2](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#method-2-separate-charts).

### Cluster Chart

[Cluster chart](cluster-chart.md) drives the provisioning of [cluster](cluster.md).
They use the templaing capability of Helm to create a dynamic configuration based on the [cluster configuration values file](cluster-values.md).

### Library

A `library chart` is a chart that has common values and function.
It is not meant to be installed. As of today, kubee has only one library chart, the `kubee-cluster` chart.

### App

All other charts are `app` charts.

## Annotations

### App Name

You can set `app.kubernetes.io/name` with the `kubee/name` annotations.
```yaml
annotations:
  app.kubernetes.io/name: mariadb
```
and 
```yaml
metadata:
  labels:
    {{- include "kubee-manifest-labels" . | indent 4}}
```

### Chart Meta (Kind, Status, ...)

Example:
```yaml
annotations:
  chart.kubee/status: "stable"
      #  "stable" - can be installed
      #  "incubator" - been developed
      #  "deprecated" - no more maintained
  # A lead, the description in Chart.yaml is a short description
  chart.kubee/lead: "A big lead"
  chart.kubee/category: monitoring 
  chart.kubee/kind: "crds"
    #  "app"  - apps
    #  "crds" - crds
    #  "cluster" - cluster driver
    #  "internal" - internal
    #  "library" - lib and shared values
  chart.kubee/engines: |
    - helm 
    - jsonnet
    - kustomize
```



### CRD Dependency Charts

You can define a CRD chart with the `chart.kubee/crds` annotations in the `Chart.yaml`.

Example:
* On a `kubee crds chart`
```yaml
annotations:
    chart.kubee/crds: |
        - name: kubee-prometheus-crds
          version: 0.79.2
          repository: file://../prometheus-crds
```
* On a `external crds chart`
```yaml
annotations:
  chart.kubee/crds: |
    - name: mariadb-operator/mariadb-operator-crds
      repository: https://helm.mariadb.com/mariadb-operator
      version: 0.37.1
```


## FAQ: Why not multiple sub-chart by umbrella chart?

SubChart cannot by default be installed in another namespace than the umbrella chart.
This is a [known issue with helm and sub-charts](https://github.com/helm/helm/issues/5358)

That's why:
* the unit of execution is one sub-chart by umbrella chart
* `kubee-cluster` is a common sub-chart of all umbrella chart


## Dev: Cross dependency

Cross Dependency are only used to share values.

When developing a Chart, you should:
* add them in `Chart.yml` and disable them with a condition
```yaml
- name: kubee-traefik
  version: 0.0.1
  alias: traefik
  condition: kubee_internal.install_cross_dependency
```
* Install them locally
```bash
kubee helmet update-dependency chart-name
# or
task dep
```

Example: The chart `kubee-dex` depends on the `kubee-oauth2-proxy` that depends on the `kubee-dex` chart
creating a recursion.

To avoid this recursion, we delete all dependency in the `charts/dep/Chart.yaml` file


## FAQ

### Why the CRDs are in the template directory and not in the CRDs directory

The crd are not in the `crds` directory
because we want this manifests to be able to upgrade.

The home of [Kubee Charts](../../docs/site/kubee-helmet-chart.md)

## Note

### Helm Schema

We filter on the current chart
because if we change a schema of a dependency,
we need to regenerate all dependent schema,
and it does not work for now.
```bash
helm schema --helm-docs-compatibility-mode -k additionalProperties --dependencies-filter kubee-mailpit
```
Why?
* because empty default value are seen as required and some dependent chart such as Traefik are out of control

To make it work, we need to create a script that make a custom call for each chart.

## Support 
### Helm Schema: no schema found error

Just FYI.
With the error:
```
If you'd like to use helm-schema on your chart dependencies as well, you have to build and unpack them before.
You'll avoid the "missing dependency" error message.
```

What they mean is when you have all your chart dependency in the `charts/`, you need to un-tar:
```bash
# go where your Chart.lock/yaml is located
cd <chart-name>

# build dependencies and untar them
helm dep build
ls charts/*.tgz |xargs -n1 tar -C charts/ -xzf
```

We tackle this problem with the `helmet update-dependency` command
