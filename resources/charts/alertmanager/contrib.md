# Contrib / Dev


## Steps

* Update the jsonnet library with the [script](download-jsonnet)
* Jb
```bash
jb init
jb install github.com/prometheus/alertmanager/doc/alertmanager-mixin@v0.28.0
jb install github.com/kubernetes-monitoring/kubernetes-mixin@af5e898 # last main commit
```
* Run
```bash
# with jsonnet
rm -rf jsonnet/multi/manifests && mkdir -p jsonnet/multi/manifests/setup && jsonnet -J vendor --multi jsonnet/multi/manifests "jsonnet/multi/alertmanager.jsonnet" --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
# with helm_x to test a cluster values
export BASHLIB_ECHO_LEVEL=4 # debug to keep the generated manifests
kube-x-helm-x --cluster clusterName template alertmanager
# to test only helm template with -s (show-only)
helm template -s templates/alertmanager-ingress.yaml --set 'kube_x.alertmanager.hostname=alert.com' . | yq
```