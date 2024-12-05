# Traefik SubChart

## About
A sub-chart of [traefik-helm-chart](https://github.com/traefik/traefik-helm-chart)

## Install

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
helm upgrade --install -n $KUBE_X_APP_NAMESPACE --create-namespace traefik .
# with kube-x
kube-x-helm upgrade --install --create-namespace traefik .
```

## Values

* [Markdown](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/VALUES.md)
* [Yaml](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml)

## Doc
### Letsencrypt

https://github.com/traefik/traefik-helm-chart/blob/master/EXAMPLES.md#use-traefik-native-lets-encrypt-integration-without-cert-manager
### Prometheus

https://github.com/traefik/traefik-helm-chart/blob/master/EXAMPLES.md#use-prometheus-operator


## CRD on K3s

On k3s, the default repo is https://hub.docker.com/r/rancher/mirrored-library-traefik/tags 
and does not have all version 3.0.3 

If you change the version, you need to apply the corresponding [crd](https://doc.traefik.io/traefik/user-guides/crd-acme/#ingressroute-definition)
otherwise you may not be able to apply specific middleware for this version

Example:
```bash
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.0.3/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
```

## Loadbalancer

The Traefik ingress controller:
* deploys a `LoadBalancer Service` that uses ports 80 and 443, 
* advertises the LoadBalancer Service's External IPs in the Status of Ingress resources it manages.

