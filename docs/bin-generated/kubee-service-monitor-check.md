# kube-service-monitor-check

Check a prometheus service-monitor for any misconfiguration

## Overview

Shows any misconfiguration of a prometheus service-monitor.

The service monitor should have the label `app.kubernetes.io/name=<app name>`

Based on [Prometheus Operator troubleshooting](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/troubleshooting.md)



## Help

Usage:

Shows the service monitor of an app

```bash
kubee-service-monitor-check <app name>
```
Note: the service monitor should have the label `app.kubernetes.io/name=<app name>`
