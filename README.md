

[//]: # (README.md generated by gotmpl. DO NOT EDIT.)

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square)

# Kubee, Kubernetes, the Easy way. Single VPS Hosting and beyond

Install in no time, in your VPS:
* [kubernetes](https://github.com/kubernetes/kubernetes), the container leader hosting platform
* and a set of integrated packaged applications (known as `charts` in Kubernetes)

## Features

* Single node Kubernetes with a goal on low memory consumption. A single node can host 110 containers, that's a lot of applications.
* Zero configuration. The [kubee charts](../../docs/site/kubee-helmet-chart.md) being aware of each other, they are preconfigured and needs a minimal set of parameters.
* Cluster configuration. Every chart configuration is saved in a [single cluster values file](../../docs/site/cluster-values.md) making it quick and easy to see the state of the cluster.
* One-shot Chart Installation. CRDs dependencies are automatically managed.

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
| [AlertManager ](charts/alertmanager/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | monitoring
| [ArgoCd ](charts/argocd/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | ci-cd
| [Cert-Manager ](charts/cert-manager/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | certificate
| [Cert-Manager Crds ](charts/cert-manager-crds/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | crds | certificate
| [Cluster ](charts/cluster/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | library | cluster
| [Dex ](charts/dex/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | auth
| [External Dns ](charts/external-dns/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | dns
| [External Secrets Charts](charts/external-secrets/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | secret
| [External Secret Crds ](charts/external-secrets-crds/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | crds | secret
| [Gogs ](charts/gogs/README.md) | [alpha](../../docs/site/kubee-helmet-chart.md#status) | app | git
| [Grafana ](charts/grafana/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | monitoring
| [Grafana Crds ](charts/grafana-crds/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | crds | monitoring
| [Healthchecks ](charts/healthchecks/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | monitoring
| [K3s-ansible Cluster ](charts/k3s-ansible/README.md) | [beta](../../docs/site/kubee-helmet-chart.md#status) | cluster | k3s
| [Keycloak ](charts/keycloak/README.md) | [alpha](../../docs/site/kubee-helmet-chart.md#status) | app | auth
| [Kubernetes Dashboard ](charts/kubernetes-dashboard/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | kubernetes
| [Kubernetes Monitoring ](charts/kubernetes-monitoring/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | kubernetes
| [Mailpit ](charts/mailpit/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | mail
| [Mail ](charts/mailu/README.md) | [alpha](../../docs/site/kubee-helmet-chart.md#status) | app | mail
| [Mariadb ](charts/mariadb/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | database
| [Node Exporter ](charts/node-exporter/README.md) | [deprecated](../../docs/site/kubee-helmet-chart.md#status) | app | monitoring
| [Oauth2-Proxy ](charts/oauth2-proxy/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | auth
| [Postal ](charts/postal/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | mail
| [Prometheus ](charts/prometheus/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | monitoring
| [Prometheus Adapter ](charts/prometheus-adapter/README.md) | [alpha](../../docs/site/kubee-helmet-chart.md#status) | app | monitoring
| [Prometheus Crds ](charts/prometheus-crds/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | crds | monitoring
| [PushGateway ](charts/pushgateway/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | monitoring
| [Traefik ](charts/traefik/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | proxy
| [Traefik Crds ](charts/traefik-crds/README.md) | [deprecated](../../docs/site/kubee-helmet-chart.md#status) | crds | proxy
| [Traefik Forward Auth ](charts/traefik-forward-auth/README.md) | [deprecated](../../docs/site/kubee-helmet-chart.md#status) | app | auth
| [Trust manager crds chart](charts/trust-manager-crds/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | crds | certificate
| [Values ](charts/values/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | internal | internal
| [Vault ](charts/vault/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | secret
| [Whoami ](charts/whoami/README.md) | [stable](../../docs/site/kubee-helmet-chart.md#status) | app | http

Note that you are not limited to Kubee Charts.
You can install yourself any chart,
but you would need to configure them yourself.

To make your charts, `kubee`  compatible and reuse the configuration of dependent chart,
you can read the [kubee chart documentation](../../docs/site/kubee-helmet-chart.md).

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
