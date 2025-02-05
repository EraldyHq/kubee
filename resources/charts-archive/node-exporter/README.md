#  Node Exporter

[Incorporated to kubernetes-monitoring](../../charts/kubernetes-monitoring/README.md)

## About
`Node exporter` is a prometheus exporter that gather OS system metrics.

This chart installs:
* Node exporter
* and the Node mixins (alert and dashboard)


It was added as a `DaemonSet` with `hostNetwork` capability.

See:
* [prometheus-node-exporter](templates/prometheus-node-exporter.yml)
* [prometheus-node-exporter service monitor](templates/prometheus-node-exporter-service-monitor.yml)

## Ref

[Ref](https://www.civo.com/learn/kubernetes-node-monitoring-with-prometheus-and-grafana)