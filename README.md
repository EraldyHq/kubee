

[//]: # (README.md generated by gotmpl. DO NOT EDIT.)

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square)

# Kubee, Kubernetes, the Easy way. Single VPS Hosting and beyond

Install in no time, in your VPS:
* [kubernetes](https://github.com/kubernetes/kubernetes), the container leader hosting platform
* and a set of integrated packaged applications (known as `charts` in Kubernetes)

## Why Easy?

Because we are starting from the `simplest Kubernetes cluster` as stated in the [official documentation](https://kubernetes.io/docs/setup/production-environment/#production-control-plane).

> The simplest Kubernetes cluster has the entire control plane
> and worker node services running on the same machine.
> You can grow that environment by adding worker nodes.

## Features

Works out of the box

* Single node Kubernetes with a goal on low memory consumption. A single node can host 110 containers, that's a lot of applications.
* Zero configuration. The [kubee charts](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md) being aware of each other, they are preconfigured and needs a minimal set of parameters.
* Cluster configuration. Every chart configuration is saved in a [single cluster values file](https://github.com/EraldyHq/kubee/blob/main/docs/site/cluster-values.md)
 making it quick and easy to see the state of the cluster.
* One-shot Chart Installation. CRDs dependencies are automatically managed.
* Authentication Ready. All infra apps are automatically secured by authentication (`basicAuth` by default, oidc if [Dex](https://github.com/EraldyHq/kubee/blob/main/charts/dex/README.md))
* Secure Ready. With the internal `kubee` ca, all communication are encrypted (ssl/https) and the servers get certificates that are automatically rotated.
* Ingress Ready. Access any service by setting just the hostname.

## App examples

* `Admin Dashboard` with [Kubernetes Dashboard](./charts/kubernetes-dashboard)
* Certificate Provisioning and monitoring with [cert-manager](./charts/cert-manager/README.md)
* Host, System and App Monitoring with [Prometheus](charts/prometheus), [Alert Manager](charts/alertmanager), [Grafana](charts/grafana/README.md), ...
* [Cron Job](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/)
* `FAAS (Function as a service)` as functions are container
* `Database provisioning` with operator such as [MariaDb](charts/mariadb/README.md), `CNPG` for postgres, ...
* `Secret Management` with [Kubernetes Secret](https://kubernetes.io/docs/tasks/configmap-secret/), [External Secret](charts/external-secrets/README.md), [Vault](charts/vault/README.md), ...)
* Self-healing mechanism with the integrated container supervisor
* No downtime thanks to [Rolling Update](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
* CI/CD Deployment with [ArgoCd](charts/argocd/README.md), Flux

## List of Kubee Charts

| Kubee Chart | Status  | Kind | Category |
|-----------|---------|------|----------|
| [AlertManager ](https://github.com/EraldyHq/kubee/blob/main/charts/alertmanager/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | monitoring  |
| [ArgoCd ](https://github.com/EraldyHq/kubee/blob/main/charts/argocd/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | ci-cd  |
| [BlackBox Exporter ](https://github.com/EraldyHq/kubee/blob/main/charts/blackbox-exporter/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | monitoring  |
| [Cert-Manager ](https://github.com/EraldyHq/kubee/blob/main/charts/cert-manager/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | certificate  |
| [Cert-Manager Crds ](https://github.com/EraldyHq/kubee/blob/main/charts/cert-manager-crds/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | crds | certificate  |
| [Cluster ](https://github.com/EraldyHq/kubee/blob/main/charts/cluster/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | library | cluster  |
| [Dex ](https://github.com/EraldyHq/kubee/blob/main/charts/dex/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | auth  |
| [External Dns ](https://github.com/EraldyHq/kubee/blob/main/charts/external-dns/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | dns  |
| [External Dns Crds ](https://github.com/EraldyHq/kubee/blob/main/charts/external-dns-crds/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | crds | dns  |
| [External Secrets Charts](https://github.com/EraldyHq/kubee/blob/main/charts/external-secrets/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | secret  |
| [External Secret Crds ](https://github.com/EraldyHq/kubee/blob/main/charts/external-secrets-crds/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | crds | secret  |
| [Gogs ](https://github.com/EraldyHq/kubee/blob/main/charts/gogs/README.md) | [alpha](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | git  |
| [Grafana ](https://github.com/EraldyHq/kubee/blob/main/charts/grafana/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | monitoring  |
| [Grafana Crds ](https://github.com/EraldyHq/kubee/blob/main/charts/grafana-crds/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | crds | monitoring  |
| [Healthchecks ](https://github.com/EraldyHq/kubee/blob/main/charts/healthchecks/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | monitoring  |
| [K3s-ansible Cluster ](https://github.com/EraldyHq/kubee/blob/main/charts/k3s-ansible/README.md) | [beta](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | cluster | k3s  |
| [Keycloak ](https://github.com/EraldyHq/kubee/blob/main/charts/keycloak/README.md) | [alpha](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | auth  |
| [Kuberhealthy ](https://github.com/EraldyHq/kubee/blob/main/charts/kuberhealthy/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | test  |
| [kuberhealthy Crds ](https://github.com/EraldyHq/kubee/blob/main/charts/kuberhealthy-crds/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | crds | monitoring  |
| [Kubernetes Dashboard ](https://github.com/EraldyHq/kubee/blob/main/charts/kubernetes-dashboard/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | kubernetes  |
| [Kubernetes Monitoring ](https://github.com/EraldyHq/kubee/blob/main/charts/kubernetes-monitoring/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | kubernetes  |
| [Mailpit ](https://github.com/EraldyHq/kubee/blob/main/charts/mailpit/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | mail  |
| [Mail ](https://github.com/EraldyHq/kubee/blob/main/charts/mailu/README.md) | [alpha](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | mail  |
| [Mariadb ](https://github.com/EraldyHq/kubee/blob/main/charts/mariadb/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | database  |
| [Node Exporter ](https://github.com/EraldyHq/kubee/blob/main/charts/node-exporter/README.md) | [deprecated](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | monitoring  |
| [Oauth2-Proxy ](https://github.com/EraldyHq/kubee/blob/main/charts/oauth2-proxy/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | auth  |
| [Postal ](https://github.com/EraldyHq/kubee/blob/main/charts/postal/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | mail  |
| [Prometheus ](https://github.com/EraldyHq/kubee/blob/main/charts/prometheus/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | monitoring  |
| [Prometheus Adapter ](https://github.com/EraldyHq/kubee/blob/main/charts/prometheus-adapter/README.md) | [alpha](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | monitoring  |
| [Prometheus Crds ](https://github.com/EraldyHq/kubee/blob/main/charts/prometheus-crds/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | crds | monitoring  |
| [PushGateway ](https://github.com/EraldyHq/kubee/blob/main/charts/pushgateway/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | monitoring  |
| [Traefik ](https://github.com/EraldyHq/kubee/blob/main/charts/traefik/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | proxy  |
| [Traefik Crds ](https://github.com/EraldyHq/kubee/blob/main/charts/traefik-crds/README.md) | [deprecated](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | crds | proxy  |
| [Traefik Forward Auth ](https://github.com/EraldyHq/kubee/blob/main/charts/traefik-forward-auth/README.md) | [deprecated](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | auth  |
| [Trust manager crds chart](https://github.com/EraldyHq/kubee/blob/main/charts/trust-manager-crds/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | crds | certificate  |
| [Vault ](https://github.com/EraldyHq/kubee/blob/main/charts/vault/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | secret  |
| [Whoami ](https://github.com/EraldyHq/kubee/blob/main/charts/whoami/README.md) | [stable](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) | app | http  |

Note that you are not limited to Kubee Charts.
You can install any Helm chart or Kubernetes Manifest, but you would need to discover the configuration yourself.

To make your charts, `kubee`  compatible and reuse the configuration of dependent charts,
you can read the [kubee chart documentation](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md).

## Steps

### Installation

On Mac / Linux / Windows WSL with HomeBrew

```bash
brew install --HEAD eraldyhq/tap/kubee
```

### Getting Started

See [How to create a cluster and install applications](docs/site/cluster-creation.md)

## Contribute

See [Contribute/Dev](contrib/contribute.md)
