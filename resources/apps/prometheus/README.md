

monitoring-mixins: https://github.com/monitoring-mixins/docs/blob/master/design.pdf

```jsonnet
local prometheusOperator = import 'github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator/prometheus-operator.libsonnet';
# https://github.com/prometheus-operator/prometheus-operator/blob/main/jsonnet/prometheus-operator/prometheus-operator.libsonnet
```

## Init
https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/customizing.md

```bash
jb init 
jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@main
# Install this file: 
# https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/refs/heads/main/jsonnet/kube-prometheus/main.libsonnet
```
```
GET https://github.com/prometheus-operator/kube-prometheus/archive/f41e7f3a7cd2bb8b53d5bcc293cffa9910995eca.tar.gz 200
GET https://github.com/brancz/kubernetes-grafana/archive/5698c8940b6dadca3f42107b7839557bc041761f.tar.gz 200
GET https://github.com/grafana/grafana/archive/1120f9e255760a3c104b57871fcb91801e934382.tar.gz 200
GET https://github.com/etcd-io/etcd/archive/b4450d510ddf0f011c874c28e95175b4bac7f6c8.tar.gz 200
GET https://github.com/prometheus-operator/prometheus-operator/archive/25e59cb0b8b0563cabfbd7e0f1464d0e0dd10672.tar.gz 200
GET https://github.com/prometheus-operator/prometheus-operator/archive/25e59cb0b8b0563cabfbd7e0f1464d0e0dd10672.tar.gz 200
GET https://github.com/kubernetes-monitoring/kubernetes-mixin/archive/13a06e4adff639de16a21142a0ec61f09f036eed.tar.gz 200
GET https://github.com/kubernetes/kube-state-metrics/archive/d3f0c1853f11b387d7dc2c89bd5e52760f65079c.tar.gz 200
GET https://github.com/kubernetes/kube-state-metrics/archive/d3f0c1853f11b387d7dc2c89bd5e52760f65079c.tar.gz 200
GET https://github.com/prometheus/node_exporter/archive/a38a5d7b489c72d77ef7f144d00f004473d977b6.tar.gz 200
GET https://github.com/prometheus/prometheus/archive/dd95a7e231d6fb12490911bd5579206c47299824.tar.gz 200
GET https://github.com/prometheus/alertmanager/archive/0d28327dd2492fc318afec42a425e8bb6f996e22.tar.gz 200
GET https://github.com/pyrra-dev/pyrra/archive/d723f4d1a066dd657e9d09c46a158519dda0faa8.tar.gz 200
GET https://github.com/thanos-io/thanos/archive/683cf171e9a8245c3639fb3d96827f9fae306180.tar.gz 200
GET https://github.com/grafana/grafonnet-lib/archive/a1d61cce1da59c71409b99b5c7568511fec661ea.tar.gz 200
GET https://github.com/grafana/grafonnet/archive/d20e609202733790caf5b554c9945d049f243ae3.tar.gz 200
GET https://github.com/jsonnet-libs/docsonnet/archive/6ac6c69685b8c29c54515448eaca583da2d88150.tar.gz 200
GET https://github.com/jsonnet-libs/xtd/archive/1199b50e9d2ff53d4bb5fb2304ad1fb69d38e609.tar.gz 200
GET https://github.com/grafana/grafonnet/archive/d20e609202733790caf5b554c9945d049f243ae3.tar.gz 200
GET https://github.com/grafana/grafonnet/archive/d20e609202733790caf5b554c9945d049f243ae3.tar.gz 200
GET https://github.com/grafana/grafonnet-lib/archive/a1d61cce1da59c71409b99b5c7568511fec661ea.tar.gz 200
GET https://github.com/grafana/jsonnet-libs/archive/c77ee91400cdfa8617c6167ced5c08791e7d5d3d.tar.gz 200
```