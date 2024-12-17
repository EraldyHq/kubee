# Cert Manager Sub-Chart


## About
This `chart` will install `cert-manager` with:
* letsencrypt as ACME server
* optional cloudflare as DNS server

2 `ClusterIssuers` will be installed
* `letsencrypt-staging` for the `staging environment (test)`
* `letsencrypt-prod` for the `production environment`

The issuers solve the challenge:

* `http01` (default, ie an A or CNAME record should be present in the DNS Zone)
* and optional `DNS01` from cloudflare (if the api token and the domains are given).


## Usage / Steps


### Enable and set your Email

* By default, `cert-manager` is disabled, it needs to be enabled.
* The email is used as account id by Letsencrypt and is mandatory.

In your helm values file, set the following [kube-x values](../kube-x/values.yaml)

```yaml
kube_x:
  cluster:
    adminUser:
      email: 'foo@bar.com'
  cert_manager:
    enabled: true
```

### Optional: Get the Cloudflare Api Key

[To get the API key](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/)

* Go to `User Profile > API Tokens > API Tokens`.
* Create a token with
    * Permissions:
        * Zone - DNS - Edit
        * Zone - Zone - Read
    * Zone Resources :
        * Include - All Zones

Set it cloudflare properties in your [values file](../kube-x/values.yaml)
```yaml
kube_x:
  cert_manager:
    dns01:
        cloudflare:
          # See cert-manager/README.md on how to get cloudflare api key
          cloudflareApiToken: 'token'
          # The dns Zone that are managed by cloudflare
          dnsZones:
            - my-apex-domain.tld
            - another-apex-domain.tld
```

### Deploy

```bash
kube-x-cluster install cert-manager
```

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

### Change the default

If a certificate was issued with `letsencrypt-staging`, you should change the default issuer to `letsencrypt-prod`
in the [kube-x values](../kube-x/values.yaml)

```yaml
kube_x:
  cert_manager:
    defaultIssuerName: 'letsencrypt-prod'
```



## Features


### Issuers

The
* `letsencrypt-staging`. This is the Default used to:
    * ensure that the verification process is working properly before moving to production.
    * without hitting the [prod rate limits](https://letsencrypt.org/docs/rate-limits/)
* `letsencrypt-prod` issues valid signed certificate


Note: In a [Staging environment](https://letsencrypt.org/docs/staging-environment/), the certificates are:
* not valid (not trusted)
* issued by:
    * Common Name (CN)	(STAGING) Counterfeit Cashew R10
    * Organization (O)	(STAGING) Let's Encrypt

You can check them in the CRD of the dashboard:
https://dashbord.example.com/#/customresourcedefinition/clusterissuers.cert-manager.io?namespace=cert-manager





    
## How to

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

## FAQ

### Default cert, what happens if the secret name is omitted in an ingress?

If the `secretName` is omitted in an `Ingress`, the `Ingress controller`
will use its default certificate.

* For traefik, [TLS default certificate](https://doc.traefik.io/traefik/https/tls/#default-certificate)


If the default certificate is not the logic that you want, 
you can use [Kyverno to set a default based on condition](https://cert-manager.io/docs/tutorials/certificate-defaults/)

* [Tuto](https://cert-manager.io/docs/devops-tips/syncing-secrets-across-namespaces/#serving-a-wildcard-to-ingress-resources-in-different-namespaces-default-ssl-certificate)

### Where are the Private Key Registration stored?

The generated client registration private key is stored in a Secret with the same name
as the issuer with `letsencrypt`, ie

* `letsencrypt-staging`
* or `letsencrypt-prod`

## Contrib / Dev

* Download dependency:
```bash
helm dependency build
```
* Verify
```bash
helm lint
helm template -s templates/cluster-issuer-acme.yaml .
helm template . --values=myvalues.yaml --show-only charts/(chart alias)/templates/deployment.yaml
```
* Install
```bash
# namespace is hardcoded in the value.yaml
# KUBE_X_APP_NAMESPACE=cert-manager
helm upgrade --install -n $KUBE_X_APP_NAMESPACE --create-namespace cert-manager .
# with kube-x
kube-x-helm upgrade --install --create-namespace cert-manager .
```