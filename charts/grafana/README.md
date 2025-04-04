

[//]: # (README.md generated by gotmpl. DO NOT EDIT.)

![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![AppVersion: v5.16.0](https://img.shields.io/badge/AppVersion-v5.16.0-informational?style=flat-square)

# Kubee Grafana Chart

## About

This app:
* installs the [Grafana Operator](#grafana-operator)
* instantiate a `Grafana Instance`

## Grafana Operator

`Grafana Operator` is a Kubernetes operator built to help you manage your Grafana instances and its resources from within Kubernetes.

The Operator can install and manage:
* local Grafana instances,
* Dashboards
* and Datasource's through Kubernetes Custom resources.

The Grafana Operator automatically syncs the Kubernetes Custom resources and the actual resources in the Grafana Instance.

## Features

### Automatic Creation of the Prometheus Data Source

This chart will create for you the Prometheus Data source automatically.

### Auth Form Protection

This chart will protect the authentication form with HTTP authentication headers.

### Support of Internal and External Grafana Instance

By default, `grafana` is installed on the cluster but if you choose `external`, you
can use a remote instance such as a [Grafana Cloud instance](https://grafana.com/docs/grafana-cloud/developer-resources/infrastructure-as-code/grafana-operator/operator-dashboards-folders-datasources/#grafana-operator-setup)

### Kubee Charts Features

  These [kubee charts](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md) add their features when `enabled`.

* [cert-manager](https://github.com/EraldyHq/kubee/blob/main/charts/cert-manager/README.md) adds [server certificates](https://cert-manager.io/docs/usage/certificate/) to the servers
* [prometheus](https://github.com/EraldyHq/kubee/blob/main/charts/prometheus/README.md) creates [metrics scraping jobs](https://prometheus.io/docs/concepts/jobs_instances/) and [alert rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)
* [traefik](https://github.com/EraldyHq/kubee/blob/main/charts/traefik/README.md) creates an [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) if hostnames are defined

## Installation

```bash
kubee --cluster cluster-name helmet play grafana
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api_token | string | `""` | The auth credential (used only for an external instance). See [doc](https://grafana.com/docs/grafana-cloud/developer-resources/infrastructure-as-code/grafana-operator/operator-dashboards-folders-datasources/#grafana-operator-setup) |
| enabled | bool | `false` | Boolean to indicate that this chart is or will be installed in the cluster |
| hostname | string | `""` | The public hostname The hostname may be used in Prometheus alert to reference dashboard For a Grafana cloud instance, you need to enter: <Grafana-cloud-stack-name>.grafana.net |
| namespace | string | `"grafana"` | The installation namespace |
| type | string | `"internal"` | The type of instance: * internal: installation of grafana in the cluster. * external: grafana api (for instance: grafana cloud instance, if external, the `api_token` is mandatory). An empty type does not install any instance |
| `grafana-operator` | | | [Optional Grafana Operator Helm Values](https://github.com/grafana/grafana-operator/blob/v5.16.0/deploy/helm/grafana-operator/values.yaml)

