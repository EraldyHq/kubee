# Kube-X Chart of kubernetes-dashboard

## About
A Kube-X Chart of the [kubernetes-dashboard](https://github.com/kubernetes/dashboard)

## Steps

### Cluster file Configuration

All configurations can be seen in their respectives `values file`
* [kubernetes_dashboard values file](values.yaml)
* [kubee values file](../kubee/values.yaml)

```yaml
kubernetes_dashboard:
  # Set a hostname if you want the dashboard to be available 
  # We recommend to use a DNS name based lookup server such as sslip.io or sslip.io
  # to not advertise it in your DNS
  hostname: ''
kubee:
  admin_user:
    # This chart creates a k8s service account
    # for this user, Change it if you want another name
    name: 'admin'
    # Not used by Kubernetes Dashboard. 
    # They use K8s RBAC. You need to create a token in the next step.
    password: ''
    # The Kubernetes role for the service account
    clusterRole: 'cluster-admin'
```

### Install

```bash
kubee-helm-x -c clusterName play kubernetes-dashboard
```

### Create token

To access your dashboard, you need a `token`.

This chart creates an account for your admin user defined in the [kubee values](../kubee/values.yaml)

* Get the `kubee.auth.admin_user` value in your cluster file. If empty, the default is [admin](../kubee/values.yaml))
```bash
kubectl -n kubernetes-dashboard create token ACCOUNT_NAME --duration=8400h
# with admin
kubectl -n kubernetes-dashboard create token admin --duration=8400h
```

### Access the dashboard

#### Via Ingress
Via ingress: https://hostname

#### Via Port forwarding

```bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443  
```
You can then access the dashboard at: https://localhost:8443

#### Via Proxy

Via API Service Proxy
```bash
kubectl proxy
```
You can then access the dashboard at http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard-kong-proxy:443/proxy/#/login




## FAQ

### Why there is no ingress basic auth protection?

The ingress cannot be protected with an authentication mechanism that uses the `Authenticate` HTTP header
such as the `basic auth` otherwise they conflict, and you get a `401` not authorized.


