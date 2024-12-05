# Traefik ConfChart

## About
A conf-chart for Traefik

## Prerequisite

CRD are a prerequisites 
The chart does not exist yet. https://github.com/traefik/traefik-helm-chart/issues/1141

Therefore, we install them via the charts. 
```bash
helm repo add traefik https://traefik.github.io/charts
helm install traefik traefik/traefik \
  -f traefik-values.yaml \
  --version 33.1.0
```

## Install SubChart

* Download dependency:
```bash
helm dependency build
```
* Verify
```bash
helm lint
# Output 3 line above and 14 below the grepped term
helm template . | grep -A 14 -B 3 'kindName'
```
* Install
```bash
# namespace is hardcoded in the value.yaml
# KUBE_X_APP_NAMESPACE=cert-manager
helm upgrade --install -n traefik --create-namespace traefik .
# with kube-x
kube-x-helm upgrade --install --create-namespace traefik .
```

## Values

* [Markdown](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/VALUES.md)
* [Yaml](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml)

## Doc

### Upgrade

https://github.com/traefik/traefik-helm-chart?tab=readme-ov-file#upgrading

### Letsencrypt

https://github.com/traefik/traefik-helm-chart/blob/master/EXAMPLES.md#use-traefik-native-lets-encrypt-integration-without-cert-manager



## CRD on K3s

On k3s, the default repo is https://hub.docker.com/r/rancher/mirrored-library-traefik/tags 
and does not have all version 3.0.3 

If you change the version, you need to apply the corresponding [crd](https://doc.traefik.io/traefik/user-guides/crd-acme/#ingressroute-definition)
otherwise you may not be able to apply specific middleware for this version

## Update CRD 

Example:
```bash
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.0.3/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
# from here
# https://github.com/traefik/traefik-helm-chart?tab=readme-ov-file#upgrading ???
kubectl apply --server-side --force-conflicts -k https://github.com/traefik/traefik-helm-chart/traefik/crds/
```

## Loadbalancer

The Traefik ingress controller:
* deploys a `LoadBalancer Service` by default that uses ports 80 and 443, 
* advertises the LoadBalancer Service's External IPs in the Status of Ingress resources it manages.

