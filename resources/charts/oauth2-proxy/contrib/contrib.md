# Dev Contrib


## Charts dir bootstrap

```bash
mkdir "charts"
ln -s $(realpath ../kubee) charts/kubee
mkdir "charts/kubee-dex"
ln -s $(realpath ../dex/Chart.yaml) charts/kubee-dex/Chart.yaml
ln -s $(realpath ../dex/values.yaml) charts/kubee-dex/values.yaml
mkdir "charts/kubee-prometheus"
ln -s $(realpath ../prometheus/Chart.yaml) charts/kubee-prometheus/Chart.yaml
ln -s $(realpath ../prometheus/values.yaml) charts/kubee-prometheus/values.yaml
mkdir "charts/kubee-cert-manager"
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml
# Pull traefik
helm pull https://github.com/oauth2-proxy/manifests/releases/download/oauth2-proxy-7.11.0/oauth2-proxy-7.11.0.tgz -d charts --untar
```

## Doc

Dex Config: https://oauth2-proxy.github.io/oauth2-proxy/configuration/providers/openid_connect
Example: https://github.com/oauth2-proxy/oauth2-proxy/tree/master/contrib/local-environment/kubernetes