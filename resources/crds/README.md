# CRD Charts


## About

These charts are dedicated Helm Chart 
that follows the [Helm CRD Method 2](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#method-2-separate-charts).


## FAQ

### Why the CRDs are in template and not in the CRDs directory

The crd are not in the `crds` directory
because we want this Chart to be able to upgrade.
