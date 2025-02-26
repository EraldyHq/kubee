# oAuth2 Proxy Kubee Chart 

## About
This Kubee Chart installs [Oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/installation) as:
* an authentication middleware (reverse proxy) 
* to allow [Traefik forward auth rule](https://doc.traefik.io/traefik/middlewares/http/forwardauth/)
* with [Dex](../dex/README.md) as identity provider


## Installation Steps

Note:
  * [Cert Manager](../cert-manager/README.md) should be available as certificate should be created to enable `https`
  * [Dex](../dex/README.md) should be configured first as `oauth2-proxy`:
    * needs to reach the Dex discovery endpoint to start
    * should be added as Dex client
    * depends on Dex for authentication

Steps:
* In your cluster values file
  * Enable `oauth2-proxy` and `dex` 
  * And set the minimal `oauth2-proxy` cluster Values files
```yaml
# oauth2_proxy minimal values
oauth2_proxy:
  enabled: true
  hostname: 'oauth2.example.com'
  auth:
    cookie_secret: '${KUBE_OAUTH2_COOKIE_SECRET}'
# Dex values
dex:
  enabled: true
  ...: ...
# Cert Manager values
cert_manager:
  enabled: true
  ...: ...
```
* Deploy [Dex](../dex/README.md)
```bash
kubee --clustert clusterName helmet play dex
```
* Deploy `oauth2-proxy`
```bash
kubee --clustert clusterName helmet play oauth2-proxy
```
* Testing:
  * Dex Integration: 
    * Go to https://oauth2.example.com
    * Try to authenticate. 
    * The flow should go through and you should see `Authenticated`
  * Forward Auth Configuration: 
    * Apply on the [whoami](../whoami/README.md) chart the `forward-auth` middleware name.
    * Try to reach the whoami hostname
* Once tested, you can then change the [auth middleware name value of Traefik](../traefik/values.yaml) to `forward-auth`
  to forward the authentication to `dex`
```yaml
auth:
  middleware_name: 'forward-auth'
```
* Redeploy the dependent charts to apply the change. ie
  * [Traefik](../traefik/README.md) for the internal dashboard
  * [Prometheus](../prometheus/README.md) for the web app
  * [Alert manager](../alertmanager/README.md) for the web app
  * [Kubernetes Dashboard](../kubernetes-dashboard/README.md) for the web app
  * ...


## Dev/Contrib

[Contrib](contrib/contrib.md)
