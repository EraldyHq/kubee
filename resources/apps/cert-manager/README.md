# Cert Manager Sub-Chart

## Install

* Download dependency:
```bash
helm dependency build
```
* Verify
```bash
helm lint
```
* Install
```bash
# namespace is hardcoded in the value.yaml
# KUBE_X_APP_NAMESPACE=cert-manager
helm upgrade --install -n $KUBE_X_APP_NAMESPACE --create-namespace cert-manager .
# with kube-x
kube-x-helm upgrade --install --create-namespace cert-manager .
```

## (optional) Test Installation

Best way to fully verify the installation is to issue a test certificate. 
Create a self-signed issuer and a certificate resource in a test namespace.
https://cert-manager.io/docs/installation/kubectl/#verify



## Features

### Self-Signed Issuer

If you don't have any DNS A record, you can `self-signed` the certificate. 
```
cert-manager.io/issuer: selfsigned-issuer
```

### Issuers

This role will create the following `ClusterIssuers`:
* `letsencrypt-staging` for the `stating environment (test)`
* `letsencrypt-prod` for the `production environment`

To issue a certificate uses:
* `letsencrypt-staging` first,
* then `letsencrypt-prod` if a certificate was issued in `staging`

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

## Issuer Solver / Challenges

The issuers solve the challenge:

* `http01` (default)
* and `DNS01` from cloudflare
    * by default, if the DNS name is of the form `*.i.first-server-apex-domain.com` (`i` stands for internal)

You can change the domain names that should be used by setting a list of DNSName
with the variable `cert_manager_dns01_dns_names`


You can check them in the CRD of the dashboard:
https://dashbord.example.com/#/customresourcedefinition/clusterissuers.cert-manager.io?namespace=cert-manager


### Private Key Registration

The generated client registration private key is stored in a Secret with the same name
as the issuer with `letsencrypt`, ie

* `letsencrypt-staging`
* or `letsencrypt-prod`


### Certificate with DNS01 Challenge

By default, the challenge is `http01` (ie an A or CNAME record should be present in the DNS Zone)
except if the domain name is listed in the `dns01` dns names.
By default, all subdomain that starts with `i` (`internal`), ie: `*.i.first-server-apex-domain.com`)

Example:

```yml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: 'cert-name'
  namespace: 'app-namespace'
spec:
  secretName: 'secret-name' # the secret created to store the signed certificate and the private key
  dnsNames:
    - 'name.i.first-server-apex-domain.com' # the SAN
  issuerRef:
    kind: ClusterIssuer
    name: 'letsencrypt-staging' # then letsencrypt-prod
```

### Metrics

https://cert-manager.io/docs/devops-tips/prometheus-metrics/


## Note


### How to get the Cloudflare Api Key (Mandatory)

[to get the API key](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/)

* Go to `User Profile > API Tokens > API Tokens`.
* Create a token with
    * Permissions:
        * Zone - DNS - Edit
        * Zone - Zone - Read
    * Zone Resources :
        * Include - All Zones

### Default cert

In an Ingress, if the `secretName` is omitted, it would
use the default wildcard certificate of the `Ingress controller`
https://cert-manager.io/docs/devops-tips/syncing-secrets-across-namespaces/#serving-a-wildcard-to-ingress-resources-in-different-namespaces-default-ssl-certificate

https://cert-manager.io/docs/tutorials/certificate-defaults/

### Backup

https://cert-manager.io/docs/devops-tips/backup/


## How to debug

https://cert-manager.io/docs/troubleshooting/acme/

## Installation Doc / Ref

* [Installing as a sub-chart](https://cert-manager.io/docs/installation/helm/#installing-cert-manager-as-subchart)
* [Helm Installation](https://cert-manager.io/docs/installation/helm/)
* https://github.com/cert-manager/cert-manager/blob/release-1.15/deploy/charts/cert-manager/README.template.md#installing-the-chart

## Example
### Wildcard example

https://github.com/traefik/traefik-helm-chart/blob/master/EXAMPLES.md#provide-default-certificate-with-cert-manager-and-cloudflare-dns
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: wildcard-example-com
spec:
  secretName: wildcard-example-com-tls
  dnsNames:
    - "example.com"
    - "*.example.com"
  issuerRef:
    name: cloudflare
    kind: Issuer
```