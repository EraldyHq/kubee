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
kube-x-helm-x -c clusertName template kubernetes-dashboard
```
* Install
```bash
kube-x-helm-x -c clusertName play kubernetes-dashboard
```
* Note: Because this a Kube-X Helm Chart only, you can use the Helm command directly (dev only)
```bash
# Only with helm
helm upgrade --install -n kubernetes-dashboard --create-namespace kubernetes-dashboard .
# with kube-x helm
kube-x-helm upgrade --install --create-namespace kubernetes-dashboard .
```



## Ref
https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard 