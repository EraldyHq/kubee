# Dev

## Helm

This chart is an umbrella chart over:
https://charts.dexidp.io/
https://github.com/dexidp/helm-charts

## Setup

```bash
mkdir "charts"
ln -s $(realpath ../kubee) charts/kubee
mkdir "charts/kubee-traefik"
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml
mkdir "charts/kubee-traefik-forward-auth"
ln -s $(realpath ../traefik-forward-auth/Chart.yaml) charts/kubee-traefik-forward-auth/Chart.yaml
ln -s $(realpath ../traefik-forward-auth/values.yaml) charts/kubee-traefik-forward-auth/values.yaml
mkdir "charts/kubee-cert-manager"
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml

# Pull
helm pull https://github.com/dexidp/helm-charts/releases/download/dex-0.20.0/dex-0.20.0.tgz -d charts --untar
```