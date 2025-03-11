# CRDs Chart


A CRDs chart is a chart that contains only [CRDS](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)


## Installation

These charts are dependencies of [app charts](app-chart.md)
and are normally not installed directly.

But you can also install them individually:

Example:
```bash
kubee -n prometheus helmet play prometheus-crds
```

## Why?

### They are not bundled with the operator

They are not bundled with the operator for [many reasons](https://helm.sh/docs/chart_best_practices/custom_resource_definitions)

One of many is that the declaration must be
registered before any resources of that CRDs kind(s) can be used, otherwise, you would get this kind of error:
```
Error: unable to build kubernetes objects from release manifest: resource mapping not found for name: 
"vault-external-secret-store" 
namespace: "external-secrets" from "": 
no matches for kind "ClusterSecretStore" in version "external-secrets.io/v1beta1"
ensure CRDs are installed first
```

### Why the CRDs are in Helm template directory and not in the CRDs directory

The crd are not in the `crds` directory
because we want this Chart to be able to upgrade.