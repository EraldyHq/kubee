# Contrib

 




## JsonNet Prometheus Mixin Bootstrap

Local:
```bash
cd cert-manager
jb update
jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "jsonnet/prometheusRule.jsonnet"))'
jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "jsonnet/grafanaDashboard.jsonnet"))'
```

## Render

```bash
kubee -c clusertName helmet template cert-manager --out
```


## FAQ
### Why not ingress traefik cert?


* No ingress dependence
* We can use the cert inside a pod to serve https
* We have the whole order to be able to debug
* We can monitor the certs and be alerted
* HA only setup - Traefik does not share certificate between instance
* HA setups without requiring you to use the enterprise version of the ingress.
    * Traefik CE (community edition) is stateless, and it's not possible to run multiple instances of Traefik CE with LetsEncrypt enabled.
* Local CA to provision self-signed certificate

### Default cert, what happens if the secret name is omitted in an ingress?

If the `secretName` is omitted in an `Ingress`, the `Ingress controller`
will use its default certificate.

* For traefik, [TLS default certificate](https://doc.traefik.io/traefik/https/tls/#default-certificate)


If the default certificate is not the logic that you want,
you can use [Kyverno to set a default based on condition](https://cert-manager.io/docs/tutorials/certificate-defaults/)

* [Tuto](https://cert-manager.io/docs/devops-tips/syncing-secrets-across-namespaces/#serving-a-wildcard-to-ingress-resources-in-different-namespaces-default-ssl-certificate)

## How to

### Create a certificate


```yml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: 'cert-name'
  namespace: 'app-namespace'
spec:
  secretName: 'secret-name' # the secret created to store the signed certificate and the private key
  dnsNames:
    - 'name.my-apex-domain.com' # the SAN
  issuerRef:
    kind: ClusterIssuer
    name: 'letsencrypt-staging' # then letsencrypt-prod
```

### How to use it with Traefik

Guide:
* [Traefik and Cert manager](https://doc.traefik.io/traefik/user-guides/cert-manager/)

Routing (Annotation):
* [Ingress](https://doc.traefik.io/traefik/routing/providers/kubernetes-ingress/)
* [Ingress Route](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/)

Providers (Configuration Discovery):
* [Ingress](https://doc.traefik.io/traefik/providers/kubernetes-ingress/)
* [Ingress Route](https://doc.traefik.io/traefik/providers/kubernetes-crd/)

### How to debug

https://cert-manager.io/docs/troubleshooting/acme/