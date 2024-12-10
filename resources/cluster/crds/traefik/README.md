# Kube-X Traefik CRDS


## About

This chart installs the Traefik CRDs.

This is a dedicated Helm Chart delivery method that 
implements the [Helm CRD Method 2](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#method-2-separate-charts).

## Install

CRD are global. No namespace is needed
```bash
helm upgrade --install -n traefik --create-namespace traefik-crds .
# with kube-x
kube-x-helm upgrade --install traefik-crds .
```

## Contrib

### How to develop

We created the [update-traefik-crds](update-traefik-crds) script
to develop/update the chart development automatically.

```bash
./update-traefik-crds
```

## FAQ

### Why the CRDs are in template and not in the CRDs directory

The crd are not in the `crds` directory
because we want this Chart to be able to upgrade.

### Where are the CRD chart on K3s

On k3s, the default repo is https://hub.docker.com/r/rancher/mirrored-library-traefik/tags
and does not have all version 3.0.3

If you change the version, you need to apply the corresponding [crd](https://doc.traefik.io/traefik/user-guides/crd-acme/#ingressroute-definition)
otherwise you may not be able to apply specific middleware for this version
