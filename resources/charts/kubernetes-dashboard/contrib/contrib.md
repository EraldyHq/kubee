# Dev/Contrib

## Chart Type

This is a umbrella chart because Kubernetes Dashboard [supports only Helm-based installation](https://github.com/kubernetes/dashboard?tab=readme-ov-file#installation)


## Charts dir bootstrap

```bash
mkdir "charts"
ln -s $(realpath ../kubee) charts/kubee
mkdir "charts/kubee-cert-manager"
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml
mkdir "charts/kubee-traefik"
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml

helm pull https://github.com/kubernetes/dashboard/releases/download/kubernetes-dashboard-7.10.4/kubernetes-dashboard-7.10.4.tgz -d charts --untar
```


## Install

* Add repo and download dependency:
```bash
# helm dependency build
helm dependency update
```
* Verify
```bash
helm lint
# output them all at out 
helm template --set 'cert_manager.enabled=true' --output-dir out .
```
* Install
```bash
kubee helmet -c clusertName play kubernetes-dashboard
```
* Note: Because this a Kubee Helm Chart only, you can use the Helm command directly (dev only)
```bash
# Only with helm
helm upgrade --install -n kubernetes-dashboard --create-namespace kubernetes-dashboard .
# with kubee helm
kubee-helm upgrade --install --create-namespace kubernetes-dashboard .
```

## FAQ

### Why there is no ingress basic auth protection?

The ingress cannot be protected with an authentication mechanism that uses the `Authenticate` HTTP header
such as the `basic auth` otherwise they conflict, and you get a `401` not authorized.

### Why there is no forward auth protection?

`Traefik-Forward-Auth` set only the `X-Forwarded-User` does not allow to set the bearer in the response
https://github.com/thomseddon/traefik-forward-auth#forwarded-headers

https://github.com/thomseddon/traefik-forward-auth/issues/30

### Auth portal


We need to use a [oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/configuration/providers/openid_connect)

as oauth2_proxy is capable of both providing the access token and refreshing the token.
* https://github.com/pusher/oauth2_proxy/blob/fb1614c87334c45a6c96f991db802c9a2c1c4a7f/contrib/oauth2_proxy.cfg.example#L43
* https://github.com/thomseddon/traefik-forward-auth/pull/100

## Ref
https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard 