# Cloudflare

Cloudflare is fully supported as DNS provider.

It can be configured by the following [Kubee Chart](kubee-helmet-chart.md)

* `Cert Manager`
* `External DNS`

## How to get the API key

Get the API key [Ref](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/)

* Go to `Cloudflare > User Profile > API Tokens > API Tokens`.
* Create a token with
* Permissions:
    * `Zone - DNS - Edit`
    * `Zone - Zone - Read`
    * Zone Resources :
        * `Include - All Zones`

