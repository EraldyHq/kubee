

[//]: # (README.md generated by gotmpl. DO NOT EDIT.)

![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![AppVersion: 7.11.0](https://img.shields.io/badge/AppVersion-7.11.0-informational?style=flat-square)

# Kubee Kubernetes Dashboard Chart

The `Kubee Kubernetes Dashboard Chart` is a [Kubee Chart](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md) that installs the [kubernetes-dashboard](https://github.com/kubernetes/dashboard).

## Features

### Auth Integration

By default, you need to create a service account token to login.
This chart includes an [auth integration](#with-auth-middleware) so that you
can log in via your identity provider.

### Kubee Charts Features

  These [kubee charts](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md) add their features when `enabled`.

* [cert-manager](https://github.com/EraldyHq/kubee/blob/main/charts/cert-manager/README.md) adds [server certificates](https://cert-manager.io/docs/usage/certificate/) to the servers
* [traefik](https://github.com/EraldyHq/kubee/blob/main/charts/traefik/README.md) creates an [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) if hostnames are defined

## Installation Steps

### Cluster Values file Configuration

Set this values in your cluster values file.
```yaml
kubernetes_dashboard:
  # Set a public hostname
  # We recommend to use a DNS name based lookup server such as sslip.io or nip.io
  # to not advertise it in your DNS
  hostname: 'dash.example.tld'
cluster:
  auth:
      admin_user:
        # admin by default
        name: 'admin'
```

### Installation

```bash
kubee --cluster cluster-name helmet play kubernetes-dashboard
```

### Access the dashboard

Access the Kubernetes dashboard at https://dash.example.tld

> [!Note]
> You can still access it without Ingress
> For Information, you can see how on this section: [How to access the dashboard without Ingress](contrib/contrib.md#how-to-access-the-dashboard-without-ingress)

## Create Access Credentials

### Without auth middleware

By default, this chart does not use an authentication middleware (`use_auth_middleware: false`).

To access your dashboard, you need to generate a `token` for this Service account

* Get the `cluster.auth.admin_user` value in your cluster file. If empty, the default is [admin](../cluster/values.yaml).
```bash
# Syntax
kubectl -n kubernetes-dashboard create token USER_NAME --duration=8400h
# with admin as username
kubectl -n kubernetes-dashboard create token admin --duration=8400h
```

### With auth middleware

When the auth middleware is applied (`use_auth_middleware: true`), the token:
* is generated by [Dex](../dex/README.md)
* returned to the Kubernetes Dashboard via [Oauth Proxy](../oauth2-proxy/README.md)

The Admin user Rbac authorizations are created by the [dex](../dex/Chart.yaml)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | bool | `false` | Boolean to indicate that this chart is or will be installed in the cluster |
| hostname | string | `""` | The public hostname If not empty, an ingress is created |
| namespace | string | `"kubernetes-dashboard"` | The installation namespace |
| use_auth_middleware | bool | `false` | Use the auth proxy middleware to login. If false, you need to enter a service account token to login. If true, you are redirected to the authentication app (ie dex) via the proxy middleware chain (ie oauth2-proxy, dex and kubernetes oidc connect) |
| kubernetes-dashboard | object | | [The kubernetes dashboard chart values](https://github.com/kubernetes/dashboard/blob/kubernetes-dashboard-7.11.0/charts/kubernetes-dashboard/values.yaml) |

## Contrib / Dev

See [contrib](contrib/contrib.md)

