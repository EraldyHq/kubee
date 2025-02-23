

## Test
### Open Relay Checker

https://mxtoolbox.com/diagnostic.aspx


## Bootstrap

```bash

mkdir charts/
ln -s $(realpath ../cluster) charts/kubee-cluster
mkdir "charts/kubee-traefik"
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml
mkdir "charts/kubee-cert-manager"
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml

helm repo add mailu https://mailu.github.io/helm-charts/
helm pull https://github.com/Mailu/helm-charts/releases/download/mailu-2.1.2/mailu-2.1.2.tgz -d charts --untar
```

