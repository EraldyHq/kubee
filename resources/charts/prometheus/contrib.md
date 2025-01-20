# Contrib Dev


## Jsonnet Bootstrap

The [jsonnet project](jsonnet/README.md) was bootstrapped with:
```bash
cd jsonnet
```
* The [kube-prometheus libs](jsonnet/download-kube-prometheus-scripts):
```bash
./download-kube-prometheus-scripts
```
* The jsonnet bundler (as seen on the [kube-prometheus jsonnetfile.json](https://github.com/prometheus-operator/kube-prometheus/blob/main/jsonnet/kube-prometheus/jsonnetfile.json)
```bash
jb init
jb install github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator@main
jb install github.com/prometheus-operator/prometheus-operator/jsonnet/mixin@main
jb install github.com/kubernetes-monitoring/kubernetes-mixin@af5e898 # last main commit
jb install github.com/prometheus/prometheus/documentation/prometheus-mixin@v3.1.0
```
* Try it out with
* Helm X
```bash
# set debug (to not delete the created manifests in the jsonnet/out directory)
export BASHLIB_ECHO_LEVEL=4
kube-x-helm-x -n prometheus template prometheus > /tmp/all.yaml
```
* or Raw Jsonnet command
```bash
cd jsonnet
rm -rf out && mkdir -p out && jsonnet -J vendor \
  --multi out \
  "main.jsonnet"  \
  --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" \
  | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
```



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