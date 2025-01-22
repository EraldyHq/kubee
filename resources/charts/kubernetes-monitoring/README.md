# Monitoring of the Kubernetes Component


## About

This chart installs monitoring for the core Kubernetes components:
* Api Server
* Dns
* Controller Manager
* Kubelet
* Scheduler


The following monitoring elements are installed for each:
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

## Support

### Kubelet SLI metrics not found

* Target Kubelet Sli Metrics at `:10250/metics/slis` is not found. `Error scraping target : server returned HTTP status 404 Not Found`
* Discussions: https://github.com/k3s-io/k3s/discussions/11637

