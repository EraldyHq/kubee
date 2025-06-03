# Traefik Contrib

## Setup

### Dependency Charts Bootstrapping

```bash
mkdir "charts"
ln -s $(realpath ../cluster) charts/kubee-cluster
mkdir "charts/kubee-prometheus"
ln -s $(realpath ../prometheus/Chart.yaml) charts/kubee-prometheus/Chart.yaml
ln -s $(realpath ../prometheus/values.yaml) charts/kubee-prometheus/values.yaml
mkdir "charts/kubee-grafana"
ln -s $(realpath ../grafana/Chart.yaml) charts/kubee-grafana/Chart.yaml
ln -s $(realpath ../grafana/values.yaml) charts/kubee-grafana/values.yaml
mkdir "charts/kubee-oauth2-proxy"
ln -s $(realpath ../oauth2-proxy/Chart.yaml) charts/kubee-oauth2-proxy/Chart.yaml
ln -s $(realpath ../oauth2-proxy/values.yaml) charts/kubee-oauth2-proxy/values.yaml
# Pull traefik
helm pull https://traefik.github.io/charts/traefik/traefik-34.3.0.tgz -d charts --untar
```

### Jsonnet Project Bootstrapping

The [jsonnet project](../jsonnet/README.md) was bootstrapped with:

```bash
cd jsonnet
```

* The [mixin util](./mixin-util)

```bash
./mixin-util
```

* The jsonnet bundler (as seen on
  the [kube-prometheus jsonnetfile.json](https://github.com/prometheus-operator/kube-prometheus/blob/main/jsonnet/kube-prometheus/jsonnetfile.json)

```bash
jb init
jb install  https://github.com/grafana/jsonnet-libs/traefik-mixin@master # last main commit
```

### Verify

* Lint

```bash
helm lint
```

* Output

```bash
kubee -c clusterName helmet template traefik --out > /tmp/all.yaml
```

### Install

```bash
kubee -c clusterName helmet play traefik
```

## FAQ: Why our own chart while k3s has a default one

Because it's too slow to update to the last version.
They were on 2 while traefik was already on 3.

## Port

* web (port 80),
* websecure (port 443),
* traefik (port 8080, dashboard)
* metrics (port 9100)

## Support

### Why a 404?

* Check the traefik dashboard for any middleware problem

### How to access the traefik dashboard

It's not possible via port forwarding `http://localhost:8080/dashboard/`
as [insecure mode](https://doc.traefik.io/traefik/operations/dashboard/#insecure-mode) is disabled.
Authentication middleware would not work as explained in the doc

The only way is to:
* edit the `IngressRoute` and to disable the auth middleware
* access the dashboard via hostname 

### Why a 500?

500 are really difficult to debug.

Possible solutions:

* Restart the auth proxy.
  If you get a 500 on a Ingress that has an auth middleware such as Oauth2, it may be caused by a
  bad certificate. The certificate is renewed but if the Oauth2 is not restarted, the old cert is still active. 

