# Dev

## Helm

This chart is an umbrella chart over:
https://charts.dexidp.io/
https://github.com/dexidp/helm-charts

## Setup

```bash
mkdir "charts"
ln -s $(realpath ../kubee) charts/kubee
ln -s $(realpath ../traefik) charts/kubee-traefik

ln -s $(realpath ../cert-manager) charts/kubee-cert-manager
ln -s $(realpath ../traefik-forward-auth) charts/kubee-traefik-forward-auth
helm pull https://github.com/dexidp/helm-charts/releases/download/dex-0.20.0/dex-0.20.0.tgz -d charts --untar
```