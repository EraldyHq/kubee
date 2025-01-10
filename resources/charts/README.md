# Charts


## About
This directory contains the charts that can be installed
with the [helx package manager](../../bin/kube-x-helm-x)

## Type

### CRDS

Charts that ends up with `crds` are CRDS charts.
These charts are dedicated Helm Chart 
that follows the [Helm CRD Method 2](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#method-2-separate-charts).

### App

Non CRD charts are app charts.

## FAQ

### Why the CRDs are in the template directory and not in the CRDs directory

The crd are not in the `crds` directory
because we want this manifests to be able to upgrade.
