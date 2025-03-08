# Healthchecks integration

## About
This Kubee Chart permits to monitor a `healthchecks` installation (by default, [healthchecks.io](https://healthchecks.io))

It doesn't support yet the installation of a [Healthchecks instance](https://github.com/healthchecks/healthchecks)

It will scrape the [Healthchecks.io prometheus endpoint](https://healthchecks.io/docs/configuring_prometheus/)

## Usage

You can use [healthchecks.io](https://healthchecks.io) to monitor:
* `healthcheck.io` itself thanks to [TargetDownAlert](https://runbooks.prometheus-operator.dev/runbooks/general/targetdown/)
* the [Watchdog alert](https://runbooks.prometheus-operator.dev/runbooks/general/watchdog/) if you have installed [AlertManager](../alertmanager/README.md)
* cron job if you don't want to use [pushgateway](../pushgateway/README.md)

## Dependency

It depends on the [Prometheus chart](../prometheus) for the scrape itself

## Metrics

You will find the metrics scrapped on this [page](https://healthchecks.io/docs/configuring_prometheus/)


