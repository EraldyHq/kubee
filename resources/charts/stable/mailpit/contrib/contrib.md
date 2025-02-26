


## Bootstrap

```bash
mkdir charts/
ln -s $(realpath ../cluster) charts/kubee-cluster
mkdir charts/kubee-cluster-0.0.1.tgz
mkdir "charts/kubee-traefik"
mkdir charts/kubee-traefik-0.0.1.tgz
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml
mkdir "charts/kubee-cert-manager"
mkdir charts/kubee-cert-manager-0.0.1.tgz
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml

helm repo add jouve https://jouve.github.io/charts//
helm pull https://github.com/jouve/charts/releases/download/mailpit-0.22.2/mailpit-0.22.2.tgz -d charts --untar
```

