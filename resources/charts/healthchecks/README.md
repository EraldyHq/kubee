# Healthckecks.io integration 

## About
This Kubee Chart permits to monitor [healthchecks.io](https://healthchecks.io).

It will scrape the [Healthchecks.io prometheus endpoint](https://healthchecks.io/docs/configuring_prometheus/)

## Usage

You can use healthcheck to monitor:
* `healthcheck.io` itself thanks to [TargetDownAlert](https://runbooks.prometheus-operator.dev/runbooks/general/targetdown/)
* the [Watchdog alert](https://runbooks.prometheus-operator.dev/runbooks/general/watchdog/)
* or any cron if you don't want to use [pushgateway](../pushgateway)

## Dependency

It depends on the [Prometheus chart](../prometheus) for the scrape itself

## Metrics

https://healthchecks.io/docs/configuring_prometheus/