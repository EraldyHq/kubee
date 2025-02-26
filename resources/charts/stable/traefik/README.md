# Kubee Traefik 


## About
The `Kubee Traefik Chart` will install:
* Traefik
* and the [Traefik Dashboard](https://monitoring.mixins.dev/traefik/)

The [traefik-crds chart](../traefik-crds/README.md) are installed automatically if
not found.


## FAQ
### Where do I set the trusted Proxy?

If you put your Cluster being a proxy such as Cloudflare. 
You need to set the trusted cidrs in the `ports.websecure.forwardedHeaders.trustedIPs`

```yaml
# Kubee Helm
traefik:
  # Traefik Helm
  traefik:
    ports:
      websecure:
        forwardedHeaders:
          trustedIPs: ['173.245.48.0/20','103.21.244.0/22','103.22.200.0/22']
```

It enables the forwarding of X-Headers 
[Doc](https://doc.traefik.io/traefik/v2.3/routing/entrypoints/#forwarded-headers)

### Where can I set the Values of the Traefik Helm Chart?

This chart is an Umbrella Chart based on the [Traefik Chart](https://github.com/traefik/traefik-helm-chart): 
* [Markdown](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/VALUES.md)
* [values.yaml](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml)

You can set this extra values under the `traefik/traefk` node of you cluster values file.
```yaml
# Kubee Traefik Helm
traefik:
  # Traefik Helm
  traefik:
    ports:
      websecure:
        forwardedHeaders:
          trustedIPs: ['173.245.48.0/20','103.21.244.0/22','103.22.200.0/22']
```


### How can I contribute (Dev)

The dev documentation is available [here](contrib/contrib.md)