# Contrib/Dev

## About

This is a `Kube-X`:
* [kustomization chart](../../../docs/bin/kube-x-helm-post-renderer.md#kustomization) because this is the official supported installation (ie [Helm is community maintained](https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/#helm))
* and [Jsonnet chart](../../../docs/bin/kube-x-helm-x.md#what-is-a-jsonnet-kube-x-chart) to install the monitoring mixin


## How to

### Test/Check template at dev

* With helm
```bash
helm template -s templates/patches/argocd-secret-patch.yaml \
  --set 'kube_x.auth.admin_user.password=welcome'  \
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

To get the Jsonnet Manifest in `jsonnet/out` 

```bash
# Debug to not delete them on exit
export BASHLIB_ECHO_LEVEL=4;
# Run
kube-x-helm-x \
  --cluster clusterName \
  template \
  argocd
  > /dev/null
```


### ArgoCd Version

The ArgoCd version is:
* in the [URL path of the kustomization file](kustomization.yml)
* in the [appVersion of the Chart manifest](Chart.yaml)