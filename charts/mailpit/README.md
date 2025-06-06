

[//]: # (README.md generated by gotmpl. DO NOT EDIT.)

![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![AppVersion: 0.22.2](https://img.shields.io/badge/AppVersion-0.22.2-informational?style=flat-square)

# Kubee Mailpit Chart

This [kubee chart](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md) installs the Mail Catcher, [Mailpit](https://github.com/axllent/mailpit).

## Features

### Automatic Routing through Traefik

The smtp port is the port `465` with TLS SNI so
that Traefik can route the mail to mailpit by hostname.

### Kubee Charts Features

  These [kubee charts](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md) add their features when `enabled`.

* [cert-manager](https://github.com/EraldyHq/kubee/blob/main/charts/cert-manager/README.md) adds [server certificates](https://cert-manager.io/docs/usage/certificate/) to the servers
* [traefik](https://github.com/EraldyHq/kubee/blob/main/charts/traefik/README.md) creates an [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) if hostnames are defined

## Installation

* In your cluster values file
```yaml
mailpit:
  enabled: true
  hostname: 'hostname.example.tld'
```
* Play

```bash
kubee --cluster cluster-name helmet play mailpit
```

* Once installed,
  * the smtp server is available:
    * at `hostname:465` in tls mode without any authentication
    * by default only for your private network if defined
  * the web server is available at https://hostname with the traefik authentication

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enable_private_network_middleware | bool | `true` | Enable private network. If true and a private network has been defined in Traefik, only the IP from the private network will be able to connect to the SMTP server |
| enabled | bool | `false` | Boolean to indicate that this chart is or will be installed in the cluster |
| hostname | string | `""` | The hostname |
| namespace | string | `"mail"` | The installation namespace |
| mailpit | object | | [the mailpit values](https://raw.githubusercontent.com/jouve/charts/refs/heads/0.22.2/charts/mailpit/values.yaml) |

