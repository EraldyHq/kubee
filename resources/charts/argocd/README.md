# ArgoCd


## About
This chart is a [Helm-x Chart](../../../docs/bin/kube-x-helm-x.md) that:
* install argocd
* and configure optionally
  * an [Ingress](templates/resources/argocd-ingress.yaml)
  * a [git repo](templates/resources/argocd-secret-repo.yaml)
  * a [github webhook](templates/resources/argocd-secret-external.yaml)
  * [mailing and a on-deployed notifications](templates/patches/argocd-notifications-cm.yaml)
  * the [ArgoCd Monitoring mixin](https://monitoring.mixins.dev/argo-cd-2/) (Prometheus Rules and Dashboards)
* [avoid CPU and memory spike on Sync by default](docs/argocd-cpu-memory-spikes.md)


## How to

### Test/Check values before installation

* With Helm-x For instance, to check the [repo creation](templates/resources/argocd-secret-repo.yaml)
```bash
kube-x-helx -c kube-x-ssh template argocd | grep 'name: argocd-secret-repo' -A 2 -B 11
```


## Dev / Contrib


### Test/Check template at dev

* With helm
```bash
helm template -s templates/patches/argocd-secret-patch.yaml \
  --set 'kube_x.cluster.adminUser.password=welcome'  \
  . | yq
```


### Debug Notifications

* Apply the patch
```bash
kubectl patch cm argocd-notifications-cm -n argocd --type merge --patch-file argo/patches/argocd-notifications-config-map-patch.yml
```
* Test
```bash
kubectl config set-context --current --namespace=argocd
argocd admin notifications template get
```

### JsonNet Prometheus Mixin

Local:
```bash
cd argocd
jb update
jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "jsonnet/prometheusRule.jsonnet"))'
jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "jsonnet/grafanaApplicationDashboard.jsonnet"))' --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }"
# xxx
```

End-to-end Test:
```bash
kube-x-helx \
  --cluster kube-x-ssh \
  template \
  argocd \
  | grep "argocd-mixin-alert-rules" -B 3 -A 30
```

### ArgoCd Version

The ArgoCd version is:
* in the [URL path of the kustomization file](kustomization.yml)
* in the [appVersion of the Chart manifest](Chart.yaml)