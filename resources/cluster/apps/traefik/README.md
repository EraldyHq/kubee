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

