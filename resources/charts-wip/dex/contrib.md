
This Chart is based on:
https://github.com/dexidp/dex/blob/master/examples/k8s/dex.yaml

## Setup

```bash
mkdir "charts"
ln -s $(realpath ../../charts/kubee) charts/kubee
ln -s $(realpath ../../charts/traefik) charts/kubee-traefik
ln -s $(realpath ../../charts/cert-manager) charts/kubee-cert-manager
```