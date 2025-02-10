# Dev/Contrib

## Chart Type

This is a umbrella chart because Kubernetes Dashboard [supports only Helm-based installation](https://github.com/kubernetes/dashboard?tab=readme-ov-file#installation)


## Install

* Add repo and download dependency:
```bash
# helm dependency build
helm dependency update
```
* Verify
```bash
helm lint
# output them all at out 
helm template --set 'cert_manager.enabled=true' --output-dir out .
```
* Install
```bash
kubee-chart -c clusertName play kubernetes-dashboard
```
* Note: Because this a Kubee Helm Chart only, you can use the Helm command directly (dev only)
```bash
# Only with helm
helm upgrade --install -n kubernetes-dashboard --create-namespace kubernetes-dashboard .
# with kubee helm
kubee-helm upgrade --install --create-namespace kubernetes-dashboard .
```



## Ref
https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard 