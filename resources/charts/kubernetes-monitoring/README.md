# Monitoring of the Kubernetes Component


## About

This chart installs the monitoring elements of Kubernetes components such as:
* prometheus scrape configuration
* prometheus alerts
* prometheus rules
* and grafana dashboard


## Optional Prerequisites: Kube-x Chart Dependency

This charts should have been enabled and installed:
  * [Grafana](../grafana/README.md) for the dashboards
  * [Prometheus](../prometheus/README.md) for the prometheus scrape, alert and rules


## Dev/Contrib

See [Dev/Contrib](contrib.md)