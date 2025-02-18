# Traefik Forward Auth

> [!WARNING]
> Deprecated for [oauth2-proxy](../oauth2-proxy/README.md)
> Why?
> Traefik Forward Auth does not support forwarding the `Authorization Header` 
> therefore it's not possible to authenticate directly to a Kubernetes Dashboard Client
> We recommend using [oauth2-proxy](../oauth2-proxy/README.md) instead.
> Ref:
> * [X-Forwarded-User is the only header](https://github.com/thomseddon/traefik-forward-auth#forwarded-headers) 
> * [Issue](https://github.com/thomseddon/traefik-forward-auth/issues/30)


This kubee chart will:
* install [traefik-forward-auth](https://github.com/thomseddon/traefik-forward-auth).
* to forward ingress authentication to [dex](../dex/README.md)

## Mode

`Traefik Forward Auth` works in [2 modes](https://github.com/thomseddon/traefik-forward-auth#operation-modes)
* the `auth host mode` (aka Single SignOn by domain) where:
  * The `Traefik Forward Auth` has a hostname `name.apex.tld`
  * All protected apps should have the same apex domain `apex.tld` as the hostname
  * This chart uses this `mode` if the hostname value is not empty.
* the `overlay mode`, where you need to register in [Dex](../dex/values.yaml) all protected apps in the redirect callback of the `traefik forward auth` client ie
  * `traefik.xxx.tld`
  * `prometheus.xxx.tld`
  * `alertmanager.xxx.tld`
  * ...


  
## Installation Steps for the Auth Host Mode

* The following chart should be enabled and installed:
  * [dex chart](../dex/README.md) 
  * [cert-manager](../cert-manager/README.md)
  * [traefik](../traefik/README.md)

* You should set at minimal the following values in your [Cluster Values file](../../../docs/site/cluster-values.md)
```yaml
traefik_forward_auth:
  enabled: true
  # For Host mode, the callback hostname (All protected apps should have the same apex domain)
  # https://github.com/thomseddon/traefik-forward-auth#auth-host-mode
  hostname: 'forward-auth.example.com'
  auth:
    # The encryption secret
    cookie_secret: 'xxxx'
```

* Installing it
```bash
kubee -cluster clusterName helmet play traefik-forward-auth
```

* Once installed, you can then change the [auth middleware name of Traefik](../traefik/values.yaml) to `forward-auth`
to forward the authentication to `dex` 
```yaml
auth:
  middleware_name: 'forward-auth'
```

* And redeploy the dependent charts to apply the change. ie 
  * [Traefik](../traefik/README.md) for the internal dashboard
  * [Dex](../dex/README.md) to add `Traefik forward auth` as client
  * [Prometheus](../prometheus/README.md) for the web app
  * [Alert manager](../alertmanager/README.md) for the web app
  * ...

