# Traefik Forward Auth


This kubee chart will install [traefik-forward-auth](https://github.com/thomseddon/traefik-forward-auth).
to forward ingress authentication to [dex](../dex/README.md)

# Installation Steps

* The following chart should be enabled and installed:
  * [dex chart](../dex/README.md) 
  * [cert-manager](../cert-manager/README.md)
  * [traefik](../traefik/README.md)

* You should set at minimal the following values in your Cluster Values file.
```yaml
traefik_forward_auth:
  enabled: true
  # The callback hostname
  hostname: 'forward-auth.example.com'
  auth:
    # The encryption secret
    cookie_secret: 'xxxx'
```

* Installing it
```bash
kubee -cluster clusterName play traefik-forward-auth
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
