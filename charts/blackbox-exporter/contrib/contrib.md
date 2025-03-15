# Contrib / Dev





## Steps

* Update/Download the dependency scripts with this script: [script](dl-dependency-scripts)
* Run
```bash
cd blackbox-exporter
task tpl
# task play
```

## Mixin

Kube-prometheus does not have any grafana dashboard Since blackbox_exporter does not ship any monitoring mixin
https://github.com/prometheus-operator/kube-prometheus/issues/1575

## Doc

https://prometheus-operator.dev/kube-prometheus/kube/blackbox-exporter/