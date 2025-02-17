# Kubee Chart of Oauth2 Proxy

## About
A Kubee Chart installation of [Oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/installation)
configured as:
* an authentication middleware to apply a Traefik forward auth rule
* with [Dex](../dex/README.md) as auth provider


## Installation Steps

* [Dex](../dex/README.md) should be installed first as Oauth2 Proxy needs to reach the Dex discovery endpoint to start
* Minimal Cluster Values files
```yaml
oauth2_proxy:
  enabled: true
  hostname: 'oauth2-xxx.nip.io'
  auth:
    cookie_secret: '${KUBE_OAUTH2_COOKIE_SECRET}'
```
* Play
```bash
kubee --clustert clusterName helmet play oauth2-proxy
```
* Test:
  * Dex Integration: 
    * Go to https://oauth2-proxy-hostname 
    * Try to authenticate. 
    * The flow should go through and you should see `Authenticated`
  * Forward Auth Configuration: 
    * Apply on the [whoami](../whoami/README.md) chart the `forward-auth` middleware.
    * Try to reach the whoami hostname


## Contrib

[Contrib](contrib/contrib.md)
