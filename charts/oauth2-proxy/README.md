

[//]: # (README.md generated by gotmpl. DO NOT EDIT.)

![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![AppVersion: 7.8.1](https://img.shields.io/badge/AppVersion-7.8.1-informational?style=flat-square)

# Kubee Oauth2-Proxy Chart

## About
This [Kubee Chart](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md) installs [Oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/) as:
* an authentication middleware (reverse proxy)
* to allow authentication via the [Traefik forward auth rule](https://doc.traefik.io/traefik/middlewares/http/forwardauth/)
* with [dex](https://github.com/EraldyHq/kubee/blob/main/charts/dex/README.md) as identity provider

## Installation Steps

Note:
* [cert-manager](https://github.com/EraldyHq/kubee/blob/main/charts/cert-manager/README.md) should be available as certificate should be created to enable `https`
* [dex](https://github.com/EraldyHq/kubee/blob/main/charts/dex/README.md) should be configured first as `oauth2-proxy`:
    * needs to reach the Dex discovery endpoint to start
    * should be added as Dex client
    * depends on Dex for authentication

Steps:
* In your [cluster values file](https://github.com/EraldyHq/kubee/blob/main/docs/site/cluster-values.md)

    * Enable `oauth2-proxy` and `dex`
    * And set the minimal `oauth2-proxy` cluster Values files
```yaml
# oauth2_proxy minimal values
oauth2_proxy:
  enabled: true
  hostname: 'oauth2.example.com'
  auth:
    cookie_secret: '${KUBE_OAUTH2_COOKIE_SECRET}'
# Dex values
dex:
  enabled: true
  ...: ...
# Cert Manager values
cert_manager:
  enabled: true
  ...: ...
```
* Deploy [dex](https://github.com/EraldyHq/kubee/blob/main/charts/dex/README.md)
```bash
kubee --cluster clusterName helmet play dex
```
* Deploy `oauth2-proxy`
```bash
kubee --cluster clusterName helmet play oauth2-proxy
```
* Testing:
    * Dex Integration:
        * Go to https://oauth2.example.com
        * Try to authenticate.
        * The flow should go through and you should see `Authenticated`
    * Forward Auth Configuration:
        * Apply on the [whoami](https://github.com/EraldyHq/kubee/blob/main/charts/whoami/README.md) chart the `forward-auth` middleware name.
        * Try to reach the whoami hostname
* Once tested, you can then change the [auth middleware name value of Traefik](https://github.com/EraldyHq/kubee/blob/main/charts/auth middleware name value of Traefik/README.md) to `forward-auth`
  to forward the authentication to `dex`
```yaml
auth:
  middleware_name: 'forward-auth'
```
* Redeploy the dependent charts to apply the change. ie
    * [traefik](https://github.com/EraldyHq/kubee/blob/main/charts/traefik/README.md) for the internal dashboard
    * [prometheus](https://github.com/EraldyHq/kubee/blob/main/charts/prometheus/README.md) for the web app
    * [alertmanager](https://github.com/EraldyHq/kubee/blob/main/charts/alertmanager/README.md) for the web app
    * [kubernetes-dashboard](https://github.com/EraldyHq/kubee/blob/main/charts/kubernetes-dashboard/README.md) for the web app
    * ...

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auth.cookie_domains | list | `[]` | Possible domains of the cookie. The longest domain matching the request's host is used (or the shortest cookie domain if there is no match). |
| auth.cookie_secret | string | `""` | Secret Mandatory: A random value used to sign cookies It must be 16, 24, or 32 bytes to create an AES cipher Example command: `dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64 | tr -d -- '\n' | tr -- '+/' '-_' ; echo` [Doc Reference](https://oauth2-proxy.github.io/oauth2-proxy/configuration/overview#generating-a-cookie-secret) |
| auth.email_addresses | list | `[]` | Authenticated email address. Only users with this email addresses will be let in The admin email is already taken into account |
| auth.email_domains | list | `["*"]` | Email Domains. Only users with this domain will be let in. Accepted value: `*` for all emails or a hostname `your.company.com` |
| auth.token_refresh_interval | int | `120` | The interval in minutes in which the refresh of the access token will happen before expiration (in minutes) `120` is the default and not `1` because of this [issue](https://github.com/oauth2-proxy/oauth2-proxy/issues/1942#issuecomment-2700271002) |
| auth.use_domain_hostname | bool | `true` | Add the domain of the hostname as cookie domain and while list domain |
| auth.whitelist_domains | list | `[]` | Whitelist domains. The allowed domains for redirection back to the original requested target |
| enabled | bool | `false` | Boolean to indicate that this chart is or will be installed in the cluster |
| hostname | string | `""` | The public hostname |
| namespace | string | `"auth"` | The installation namespace |
| version | string | `"v7.8.1"` | The oauth-proxy [release version](https://github.com/oauth2-proxy/oauth2-proxy/releases) |
| oauth2-proxy | object | | [Chart Oauth2-proxy values](https://github.com/oauth2-proxy/manifests/blob/oauth2-proxy-7.8.1/helm/oauth2-proxy/values.yaml) |

## Contrib / Dec

Dev and contrib documentation can be found [here](contrib/contrib.md)

