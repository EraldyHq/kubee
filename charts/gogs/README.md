

[//]: # (README.md generated by gotmpl. DO NOT EDIT.)

![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![AppVersion: 0.13](https://img.shields.io/badge/AppVersion-0.13-informational?style=flat-square)

# Kubee Gogs Chart

> [!WARNING]
> This chart is in the [alpha status](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md#status) and is not fit to be installed or upgraded

This [kubee crds chart](https://github.com/EraldyHq/kubee/blob/main/docs/site/crds-chart.md) installs the `Git service` [Gogs](https://gogs.io/)

`WIP: Not finished`

## Features

### Kubee Charts Features

  These [kubee charts](https://github.com/EraldyHq/kubee/blob/main/docs/site/kubee-helmet-chart.md) add their features when `enabled`.

## Installation

```bash
kubee --cluster cluster-name helmet play gogs
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| kubee.gogs.enabled | bool | `false` |  |
| kubee.gogs.hostname | string | `""` |  |
| kubee.gogs.namespace | string | `"gogs"` |  |

## Dev/Contrib

See [Contrib](contrib.md)

