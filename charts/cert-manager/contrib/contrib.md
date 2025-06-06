# Contrib



## Bootstrap Helm Charts

```bash
mkdir "charts"
ln -s $(realpath ../cluster) charts/kubee-cluster
mkdir "charts/kubee-traefik"
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml
mkdir "charts/kubee-cert-manager"
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml
mkdir "charts/kubee-traefik-forward-auth"
ln -s $(realpath ../traefik-forward-auth/Chart.yaml) charts/kubee-traefik-forward-auth/Chart.yaml
ln -s $(realpath ../traefik-forward-auth/values.yaml) charts/kubee-traefik-forward-auth/values.yaml
mkdir "charts/kubee-oauth2-proxy"
ln -s $(realpath ../oauth2-proxy/Chart.yaml) charts/kubee-oauth2-proxy/Chart.yaml
ln -s $(realpath ../oauth2-proxy/values.yaml) charts/kubee-oauth2-proxy/values.yaml
# Pull
helm pull https://github.com/dexidp/helm-charts/releases/download/dex-0.20.0/dex-0.20.0.tgz -d charts --untar
```


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

### DNS01 or HTTP01?

With Http01, it is your responsibility to point each domain name at the correct IP address for your ingress controller.

Wildcard certificates are not supported with HTTP01 validation and require DNS01.

This is the default configuration if there is no DNS challenge configured for the domain,
You need then to update your DNS to add an A or CNAME record to point the domain name at the correct IP address


### Why not ingress traefik cert?


* No ingress dependence
* We can use the cert inside a pod to serve https
* We have the whole order to be able to debug
* We can monitor the certs and be alerted
* HA only setup - Traefik does not share certificate between instance
* HA setups without requiring you to use the enterprise version of the ingress.
    * Traefik CE (community edition) is stateless, and it's not possible to run multiple instances of Traefik CE with LetsEncrypt enabled.
* Local CA to provision self-signed certificate
* Database Operator such as MariaDb integrate with a cluster issuer to get the certificate
* Traefik store in the json file, cert-manager stores the certs in etcd.


### Default cert, what happens if the secret name is omitted in an ingress?

If the `secretName` is omitted in an `Ingress`, the `Ingress controller`
will use its default certificate.

* For traefik, [TLS default certificate](https://doc.traefik.io/traefik/https/tls/#default-certificate)


If the default certificate is not the logic that you want,
you can use [Kyverno to set a default based on condition](https://cert-manager.io/docs/tutorials/certificate-defaults/)

* [Tuto](https://cert-manager.io/docs/devops-tips/syncing-secrets-across-namespaces/#serving-a-wildcard-to-ingress-resources-in-different-namespaces-default-ssl-certificate)

### Where are the Letsencrypt Private Key Registration stored?

The generated client registration private key is stored in a Secret with the same name
as the issuer with `letsencrypt`, ie

* `letsencrypt-staging`
* or `letsencrypt-prod`

### Why Cert Manager does not have a specific CRD chart

They use a keep policy on each CRD to not delete them if the chart is deleted.
Example:
```gotemplate
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  {{- if .Values.crds.keep }}
  annotations:
    helm.sh/resource-policy: keep
  {{- end }}
```

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

### How Trust Manager updates the latest root CA certificates

It does it by using this [container](https://quay.io/repository/jetstack/trust-pkg-debian-bookworm?tab=tags) that packages the ca-certificates  from the Debian Bookworm container.

This container enables the `useDefaultCAs` in Bundle

This container is then run as an init container in the `trust-manager` pod.

Little script to check if the last root CA bundle is up-to-date
```bash
ACTUAL_TAG=$(kubee -c beau helm get values --all -n cert-manager cert-manager | yq '.trust-manager.defaultPackageImage.tag')
source <(curl -s https://raw.githubusercontent.com/cert-manager/trust-manager/refs/heads/main/make/00_debian_bookworm_version.mk)
if [ "$DEBIAN_BUNDLE_BOOKWORM_VERSION" != "$ACTUAL_TAG" ]; then
  echo "Debian Bundle Updated to $DEBIAN_BUNDLE_BOOKWORM_VERSION in place of $ACTUAL_TAG"
  exit 1
fi
```

You can override the default with this Helm chart values configuration:
```yaml
defaultPackageImage:
  repository: quay.io/jetstack/trust-pkg-debian-bookworm
  tag: "20230311.0" # quotes are important
```

Note: They update the image tag with this [script](https://github.com/cert-manager/trust-manager/blob/v0.16.0/make/debian-trust-package-fetch.sh) in this [file](https://github.com/cert-manager/trust-manager/blob/v0.16.0/make/00_debian_bookworm_version.mk)

[Ref Documentation](https://cert-manager.io/docs/trust/trust-manager/#securely-maintaining-a-trust-manager-installation)

### UI

* Headlamp Plugin
* Kubenav Plugin

## Support

### CertManagerCertExpirySoon

The `certmanager_certificate_expiration_timestamp_seconds` is the `Not After`
(some it's not updated, restarting cert-manager solves the problem)
