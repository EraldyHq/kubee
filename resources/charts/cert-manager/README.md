# Kubee Cert Manager Chart


## About
This `kubee chart` will install `cert-manager` with:
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

In your helm values file, set the following [kubee values](../kubee/values.yaml)

```yaml
kubee:
  auth:
    admin_user:
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

Set it cloudflare properties in your [values file](values.yaml)
```yaml
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
kubee --cluster clusterName helmet play cert-manager
```


### Change the default issuer

If a certificate was issued with `letsencrypt-staging`, you should change the default issuer to `letsencrypt-prod`
in the [cluster values file](../../../docs/site/cluster-values.md)

```yaml
cert_manager:
  issuer_name: 'letsencrypt-prod'
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



### Where are the Private Key Registration stored?

The generated client registration private key is stored in a Secret with the same name
as the issuer with `letsencrypt`, ie

* `letsencrypt-staging`
* or `letsencrypt-prod`

## Contrib / Dev

See [contrib](contrib/contrib.md)