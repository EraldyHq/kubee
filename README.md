
[//]: # (README.md generated by gotmpl. DO NOT EDIT.)

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square)

# Kubee, Kubernetes, the Easy way. Single VPS Hosting and beyond

Install in no time, in your VPS:
* [kubernetes](https://github.com/kubernetes/kubernetes), the container leader hosting platform
* and a set of integrated packaged applications (known as `charts` in Kubernetes)

## Features

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

## List of Charts

| Kubee Chart | Description | Status | Kind | Category |
|------------------|-------------|--------|------|----------|
| [alertmanager](charts/alertmanager/README.md) | Kubee AlertManager Chart | stable | app | monitoring
| [argocd](charts/argocd/README.md) | Kubee ArgoCd Chart | stable | app | ci-cd
| [cert-manager](charts/cert-manager/README.md) | Kubee Cert-Manager Chart | stable | app | certificate
| [cert-manager-crds](charts/cert-manager-crds/README.md) | Kubee Cert-Manager Crds Chart | stable | crds | certificate
| [cluster](charts/cluster/README.md) | Kubee Cluster Chart | stable | library | cluster
| [dex](charts/dex/README.md) | Kubee Dex Chart | stable | app | auth
| [external-dns](charts/external-dns/README.md) | Kubee External Dns Chart | stable | app | dns
| [external-secrets](charts/external-secrets/README.md) | Kubee External Secrets Charts | stable | app | secret
| [external-secrets-crds](charts/external-secrets-crds/README.md) | Kubee External Secret Crds Chart | stable | crds | secret
| [gogs](charts/gogs/README.md) | Kubee Gogs Chart | alpha | app | git
| [grafana](charts/grafana/README.md) | Kubee Grafana Chart | stable | app | monitoring
| [grafana-crds](charts/grafana-crds/README.md) | Grafana CRDS | stable | crds | monitoring
| [healthchecks](charts/healthchecks/README.md) | Kubee Healthchecks Chart | stable | app | monitoring
| [k3s-ansible](charts/k3s-ansible/README.md) | K3s Ansible Kubee Chart | beta | cluster | k3s
| [keycloak](charts/keycloak/README.md) | A kubee keycloak chart | na | na | na
| [kubernetes-dashboard](charts/kubernetes-dashboard/README.md) | Kubernetes Dashboard Kubee Chart | na | na | na
| [kubernetes-monitoring](charts/kubernetes-monitoring/README.md) | Kubee Kubernetes Monitoring Chart | na | na | na
| [mailpit](charts/mailpit/README.md) | Kubee Mailpit Chart | na | na | na
| [mailu](charts/mailu/README.md) | Kubee Mail Chart | na | na | na
| [mariadb](charts/mariadb/README.md) | Kubee Mariadb Chart | na | na | na
| [node-exporter](charts/node-exporter/README.md) | Kubee Node Exporter Chart | na | na | na
| [oauth2-proxy](charts/oauth2-proxy/README.md) | The oauth2-proxy kubee chart | na | na | na
| [postal](charts/postal/README.md) | Kubee Postal Chart | na | na | na
| [prometheus](charts/prometheus/README.md) | Kubee Prometheus Chart | na | na | na
| [prometheus-adapter](charts/prometheus-adapter/README.md) | Kubee Prometheus Adapter Chart | na | na | na
| [prometheus-crds](charts/prometheus-crds/README.md) | Kubee Prometheus CRDS Chart | na | na | na
| [pushgateway](charts/pushgateway/README.md) | Kubee PushGateway Chart | na | na | na
| [traefik](charts/traefik/README.md) | A sub-chart of Traefik | na | na | na
| [traefik-crds](charts/traefik-crds/README.md) | A Helm chart for Kubernetes | na | na | na
| [traefik-forward-auth](charts/traefik-forward-auth/README.md) | traefik-forward-auth for the Kubee Platform | deprecated | app | auth
| [trust-manager-crds](charts/trust-manager-crds/README.md) | Kubee Trust manager crds chart | stable | crds | certificate
| [values](charts/values/README.md) | A Values Helm chart | stable | internal | internal
| [vault](charts/vault/README.md) | Kubee Vault Chart | stable | app | secret
| [whoami](charts/whoami/README.md) | Kubee Whoami Chart | stable | app | ingress

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
