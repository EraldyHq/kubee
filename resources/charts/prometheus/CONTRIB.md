


### Develop the Manifest Ops

Once, create the namespace
```bash
kubectl create namespace kube-prometheus
```

Then:
* with `kube-x-kubectl`
```bash
kube-x-kubectl apply --server-side -k .
# why `--server-side` because https://github.com/prometheus-operator/kube-prometheus/issues/1511
```

* with `kubectl`
```bash
kubectl config set-context --current --namespace=kube-prometheus
kubectl apply --server-side -k .
# why `--server-side` because https://github.com/prometheus-operator/kube-prometheus/issues/1511
```