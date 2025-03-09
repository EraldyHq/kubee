

## Type

### CRDS

Charts that ends up with `crds` are CRDS charts.
These charts are dedicated Helm Chart
that follows the [Helm CRD Method 2](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#method-2-separate-charts).

### App

Non CRD charts are app charts.

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

### Chart Kind and Status

Example:
```yaml
annotations:
  chart.kubee/status: "stable"
      #  "stable" - can be installed
      #  "incubator" - been developed
      #  "deprecated" - no more maintained
  chart.kubee/type: "crds"
    #  "app"  - apps
    #  "crds" - can be installed
    #  "cluster" - been developed
    #  "internal" - internal
  chart.kubee/kind: |
    - helm # helm only
    - jsonnet # needs jsonnet
    - kustomize # neets kustomize
```



### CRD Dependency Charts

By default, `kubee helmet` will look for a Chart called `kubee-(chartName)-crds`.

You can define an external CRD chart with the `chart.kubee/crds` annotations in the `Chart.yaml`.

Example:
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

## Helm Schema

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

## Helm Schema: no schema found error

Just FYI.
With the error:
```
If you'd like to use helm-schema on your chart dependencies as well, you have to build and unpack them before.
You'll avoid the "missing dependency" error message.
```

What they mean is when you have all your chart dependency in the `charts/`, you need:
```bash
# go where your Chart.lock/yaml is located
cd <chart-name>

# build dependencies and untar them
helm dep build
ls charts/*.tgz |xargs -n1 tar -C charts/ -xzf
```


## FAQ

### Why the CRDs are in the template directory and not in the CRDs directory

The crd are not in the `crds` directory
because we want this manifests to be able to upgrade.

The home of [Kubee Charts](../../docs/site/kubee-helmet-chart.md)