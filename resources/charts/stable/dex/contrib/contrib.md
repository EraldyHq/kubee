# Dev

## Helm

This chart is an umbrella chart over:
https://charts.dexidp.io/
https://github.com/dexidp/helm-charts

## Bootstrap Helm Charts 

```bash
mkdir "charts"
ln -s $(realpath ../cluster) charts/kubee-cluster
mkdir "charts/kubee-traefik"
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml
mkdir "charts/kubee-cert-manager"
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml
mkdir "charts/kubee-traefik-forward-auth"
ln -s $(realpath ../traefik-forward-auth/Chart.yaml) charts/kubee-traefik-forward-auth/Chart.yaml
ln -s $(realpath ../traefik-forward-auth/values.yaml) charts/kubee-traefik-forward-auth/values.yaml
mkdir "charts/kubee-oauth2-proxy"
ln -s $(realpath ../oauth2-proxy/Chart.yaml) charts/kubee-oauth2-proxy/Chart.yaml
ln -s $(realpath ../oauth2-proxy/values.yaml) charts/kubee-oauth2-proxy/values.yaml
# Pull
helm pull https://github.com/dexidp/helm-charts/releases/download/dex-0.20.0/dex-0.20.0.tgz -d charts --untar
```

## FAQ

### Why? No groups for static users

Not supported https://github.com/dexidp/dex/issues/1080

Solution:
* Waiting for the merge
* [kanidm](https://kanidm.github.io/kanidm/stable/examples/kubernetes_ingress.html) implementation (as they state to be low memory)


### How to I check the installation

Once installed, you should be able to query the discovery endpoint
https://hostname/.well-known/openid-configuration

### Why do I get a 404 Not Found on the hostname

https://hostname/ is not an entrypoint and returns `404`
Check the [discovery file](#how-to-i-check-the-installation) for all endpoints.

### Why do i need to restart after a config change?

The [Helm Chart Roll Deployment](https://helm.sh/docs/howto/charts_tips_and_tricks/#automatically-roll-deployments)
is on the Dex Helm deployment chart.

We can't trick it to apply the checksum on our configuration.