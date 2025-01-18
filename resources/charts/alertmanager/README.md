# Prometheus Alert Manager


## About
The alert manager manages alerts created by the Prometheus server.

It can:
* aggregate them,
* silence them,
* route them to:
  * email 
  * or an external incident management platform such as OpsGenie. 

## Install

```bash
helx --cluster clusterName alertmanager
```


## Chart Features

* Alert Notifications Channels
  * Email 
  * OpsGenie
* Ingress
* Alert manager Monitoring:
  * Metrics Collection 
  * [Alerts](https://runbooks.prometheus-operator.dev/runbooks/alertmanager/)

## Contrib

See [contrib/dev](contrib.md)

