# Dev/Contrib

## Chart Type

This is a umbrella chart because Kubernetes Dashboard [supports only Helm-based installation](https://github.com/kubernetes/dashboard?tab=readme-ov-file#installation)


## Charts dir bootstrap

```bash
 kubee helmet update-dependencies kubernetes-dashboard
```


## Test

* Verify
```bash
helm lint
# output them all at out 
kubee helmet -c clusertName template kubernetes-dashboard --out
```
## Install

```bash
kubee helmet -c clusertName play kubernetes-dashboard
```


## FAQ


### Why there is no ingress basic auth protection?

The ingress cannot be protected with an authentication mechanism that uses the `Authenticate` HTTP header
such as the `basic auth` otherwise they conflict, and you get a `401` not authorized.

### How to access the dashboard without Ingress
* Via Port forwarding

```bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443  
```
You can then access the dashboard at: https://localhost:8443

*  Via Proxy: Via API Service Proxy
```bash
kubectl proxy
```
You can then access the dashboard at http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard-kong-proxy:443/proxy/#/login


## Ref

https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard 