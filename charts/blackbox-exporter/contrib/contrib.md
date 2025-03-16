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

## Modules

We use `helm.sh/resource-policy: keep` so that the user can generate the modules with `helm`.

Ownership still needs to be patched from `blackbox-exporter`
Example:
```bash
kubectl patch --type=strategic  configmap blackbox-exporter-configuration -n monitoring -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "blackbox-conf"}}}'
```

## Doc

https://prometheus-operator.dev/kube-prometheus/kube/blackbox-exporter/