
## Contrib

### How to develop

We created the [update-traefik-crds](update-traefik-crds) script
to develop/update the chart development automatically.

```bash
./update-traefik-crds
```

## FAQ

### Where are the CRD chart on K3s

On k3s, the default repo is https://hub.docker.com/r/rancher/mirrored-library-traefik/tags
and does not have all version 3.0.3

If you change the version, you need to apply the corresponding [crd](https://doc.traefik.io/traefik/user-guides/crd-acme/#ingressroute-definition)
otherwise you may not be able to apply specific middleware for this version
