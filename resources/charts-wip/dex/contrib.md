


## Setup

```bash
mkdir "charts"
ln -s $(realpath ../../charts/kubee) charts/kubee
ln -s $(realpath ../../charts/traefik) charts/kubee-traefik
ln -s $(realpath ../../charts/cert-manager) charts/kubee-cert-manager
helm pull https://github.com/dexidp/helm-charts/releases/download/dex-0.20.0/dex-0.20.0.tgz -d charts --untar
```