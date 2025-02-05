# Kube-X Traefik 


## About
The `Kubee Traefik sub-chart` will install Traefik. 

## Prerequisite

* [traefik-crds](../traefik-crds/README.md)

## Traefik Values

* [Markdown](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/VALUES.md)
* [Yaml](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml)


## Contrib / Dev

* Download dependency:
```bash
helm dependency update # update the dependencies (ie kubee if changed version or not)
```
* Verify
```bash
helm lint
helm template -s templates/deployment.yaml .
helm template . --values=myvalues.yaml --show-only charts/(chart alias)/templates/deployment.yaml
```
* Install
```bash
# namespace is hardcoded in the value.yaml
# KUBEE_APP_NAMESPACE=cert-manager
helm upgrade --install -n traefik --create-namespace traefik .
# with kubee
kubee-helm upgrade --install --create-namespace -f global-values.yaml  traefik .
```
