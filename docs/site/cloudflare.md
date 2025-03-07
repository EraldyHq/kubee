# Cloudflare

Cloudflare is supported as DNS provider.

It's used by the following [Kubee Chart](kubee-helmet-chart.md)
* `Cert Manager`
* `External DNS`


## How to configure it

### Get the API key
Get the API key [Ref](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/)
    * Go to `Cloudflare > User Profile > API Tokens > API Tokens`.
    * Create a token with
    * Permissions:
        * `Zone - DNS - Edit`
        * `Zone - Zone - Read`
        * Zone Resources :
            * `Include - All Zones`

### Set the cloudflare properties in your cluster values file.

#### For a Kubernetes Secret

```yaml
cluster:
    dns:
        cloudflare:
          api_token:
            value: '${KUBEE_CLOUDFLARE_API_TOKEN}'
          # The dns Zone that are managed by cloudflare
          dns_zones:
            - my-apex-domain.tld
            - another-apex-domain.tld
```

#### For a External Secret

If you installed the Kubee external secret chart, you can create an external secret instead.
```yaml
cluster:
    dns:
        cloudflare:
          api_token:
            type: 'external-secret'
            key: 'the-external-secret-key'
            property: 'the-external-secret-property'
          # The dns Zone that are managed by cloudflare
          dns_zones:
            - my-apex-domain.tld
            - another-apex-domain.tld
```

