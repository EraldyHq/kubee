# Traefik Contrib


## Setup

### Create Dependency

```bash
mkdir "charts"
ln -s $(realpath ../kubee) charts/kubee
mkdir "charts/kubee-prometheus"
ln -s $(realpath ../prometheus/Chart.yaml) charts/kubee-prometheus/Chart.yaml
ln -s $(realpath ../prometheus/values.yaml) charts/kubee-prometheus/values.yaml
mkdir "charts/kubee-grafana"
ln -s $(realpath ../grafana/Chart.yaml) charts/kubee-grafana/Chart.yaml
ln -s $(realpath ../grafana/values.yaml) charts/kubee-grafana/values.yaml
mkdir "charts/kubee-traefik-forward-auth"
ln -s $(realpath ../traefik-forward-auth/Chart.yaml) charts/kubee-traefik-forward-auth/Chart.yaml
ln -s $(realpath ../traefik-forward-auth/values.yaml) charts/kubee-traefik-forward-auth/values.yaml
mkdir "charts/kubee-oauth2-proxy"
ln -s $(realpath ../oauth2-proxy/Chart.yaml) charts/kubee-oauth2-proxy/Chart.yaml
ln -s $(realpath ../oauth2-proxy/values.yaml) charts/kubee-oauth2-proxy/values.yaml
# Pull traefik
helm pull https://traefik.github.io/charts/traefik/traefik-34.3.0.tgz -d charts --untar
```

### Verify

* Lint
```bash
helm lint
```
* Output
```bash
kubee -c clusterName helmet template traefik --out
```

### Install

```bash
kubee -c clusterName helmet template traefik --out
```


## FAQ: Why our own chart while k3s has a default one

Because it's too slow to update to the last version.
They were on 2 while traefik was already on 3.