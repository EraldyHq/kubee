# Prometheus Operator CRDS


## About

This is a `kubee` chart that installs the CRDS of the Prometheus Operator.


## Install

This chart is automatically installed when the [prometheus chart](../prometheus) is installed

You can also install it individually with:

```bash
kubee-chart -n prometheus play prometheus-crds
```

## Inspect

The output of this chart can be inspected with:
```bash
# set debug (to not delete the created manifests in the jsonnet/out directory)
export BASHLIB_ECHO_LEVEL=4
kubee-chart -n prometheus template prometheus-crds > /tmp/all.yaml
```

## List

CRD's and there respective link to the documentation:
* [alertmanagerconfigs.monitoring.coreos.com](https://prometheus-operator.dev/docs/developer/alerting/#using-alertmanagerconfig-resources) - Alert manager config creation
* [alertmanagers.monitoring.coreos.com](https://prometheus-operator.dev/docs/platform/platform-guide/#deploying-alertmanager) - Alert manager instance creation
* [podmonitors.monitoring.coreos.com](https://prometheus-operator.dev/docs/developer/getting-started/#using-podmonitors) - Prometheus scrape config for pods
* [probes.monitoring.coreos.com](https://prometheus-operator.dev/docs/getting-started/design/?#probe) - Probe definition for black box exporter
* [prometheuses.monitoring.coreos.com](https://prometheus-operator.dev/docs/platform/platform-guide/#deploying-prometheus) - Prometheus instance creation
* [prometheusagents.monitoring.coreos.com](https://prometheus-operator.dev/docs/platform/prometheus-agent/) - Prometheus agent instance creation
* [prometheusRules.monitoring.coreos.com](https://prometheus-operator.dev/docs/developer/alerting/#deploying-prometheus-rules) - Prometheus alerting and recording Rules definition
* [scrapeconfig.monitoring.coreos.com](https://prometheus-operator.dev/docs/developer/scrapeconfig/) - Prometheus Scrape Config for external kubernetes target
* [servicemonitor.monitoring.coreos.com](https://prometheus-operator.dev/docs/developer/getting-started/#using-servicemonitors) - Prometheus Scrape Config for service
* [thanosruler.monitoring.coreos.com](https://prometheus-operator.dev/docs/platform/thanos/) - [Thanos Ruler](https://prometheus-operator.dev/docs/platform/thanos/#thanos-ruler)

See also:
* the design page: [Design](https://prometheus-operator.dev/docs/getting-started/design/)
* the API for fields definitions: https://prometheus-operator.dev/docs/api-reference/api/

## Note
### Why we don't use the Community Chart

They are also available in the community chart [prometheus-operator-crds](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-operator-crds)
We have it here to be able to install it automatically as dependency of [the prometheus chart](../prometheus/README.md)

### Dev / Contrib

[contrib](contrib.md)