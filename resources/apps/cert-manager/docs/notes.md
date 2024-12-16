# Notes


## (optional) Test Installation

Best way to fully verify the installation is to issue a test certificate.
Create a self-signed issuer and a certificate resource in a test namespace.
https://cert-manager.io/docs/installation/kubectl/#verify

## Self-Signed Issuer

If you don't have any DNS A record, you can `self-signed` the certificate.
```
cert-manager.io/issuer: selfsigned-issuer
```

### Metrics

https://cert-manager.io/docs/devops-tips/prometheus-metrics/

### Backup

https://cert-manager.io/docs/devops-tips/backup/



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