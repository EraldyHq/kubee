

[//]: # (README.md generated by gotmpl. DO NOT EDIT.)

![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![AppVersion: v0.0.1](https://img.shields.io/badge/AppVersion-v0.0.1-informational?style=flat-square)

# Kubee Healthchecks Chart

This [Kubee Chart](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md) permits to monitor a `healthchecks` installation (by default, [healthchecks.io](https://healthchecks.io))

It doesn't support yet the installation of a [Healthchecks instance](https://github.com/healthchecks/healthchecks) on the cluster.

## Usage

You can use `healthcheck.io` as:
* [Watchdog](https://runbooks.prometheus-operator.dev/runbooks/general/watchdog/) if you have installed [alertManager](https://github.com/EraldyHq/kubee/blob/main/charts/alertManager/README.md) 
* cron job monitor if you don't want to use [pushgateway](https://github.com/EraldyHq/kubee/blob/main/charts/pushgateway/README.md)

## Features

### Metrics Scraping

It will scrape the [Healthchecks.io prometheus endpoint](https://healthchecks.io/docs/configuring_prometheus/)

You will find the metrics scrapped on this [page](https://healthchecks.io/docs/configuring_prometheus/)

### healthcheck.io Monitoring

This chart aims to monitor `healthcheck.io` itself thanks to [TargetDownAlert](https://runbooks.prometheus-operator.dev/runbooks/general/targetdown/)

### Kubee Charts Features

  These [kubee charts](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md) add their features when `enabled`.

* [prometheus](https://github.com/EraldyHq/kubee/blob/main/charts/prometheus/README.md) creates [metrics scraping jobs](https://prometheus.io/docs/concepts/jobs_instances/) and [alert rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)

## Installation

```bash
kubee --cluster cluster-name helmet play healthchecks
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | bool | `false` | Boolean to indicate that this chart is or will be installed in the cluster |
| hostname | string | `"healthchecks.io"` | The public hostname |
| namespace | string | `"monitoring"` | The installation namespace |
| project_uuids | list | `[]` | [Projects uuid](https://healthchecks.io/docs/configuring_prometheus/) to monitor |
| read_only_api_key | string | `""` | The [api key](https://healthchecks.io/docs/configuring_prometheus/). The auth credential (used for an external instance) |

