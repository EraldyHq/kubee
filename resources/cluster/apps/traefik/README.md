# Kube-X Traefik 


## About
A `Traefik sub-chart` for Kube-x

## Prerequisite

* [traefik-crds](../../crds/traefik/README.md)

## Install SubChart

* Download dependency:
```bash
helm dependency build
```
* Verify
```bash
helm lint
helm template -s templates/deployment.yaml .
helm template -s templates/traefik-middleware-basic-auth.yml --set 'kube_x.cluster.adminUser.password=yolo' .
helm template . --values=myvalues.yaml --show-only charts/(chart alias)/templates/deployment.yaml
```
* Install
```bash
# namespace is hardcoded in the value.yaml
# KUBE_X_APP_NAMESPACE=cert-manager
helm upgrade --install -n traefik --create-namespace traefik .
# with kube-x
kube-x-helm upgrade --install --create-namespace -f global-values.yaml  traefik .
```

## Values

* [Markdown](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/VALUES.md)
* [Yaml](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml)

## Doc


### Letsencrypt

https://github.com/traefik/traefik-helm-chart/blob/master/EXAMPLES.md#use-traefik-native-lets-encrypt-integration-without-cert-manager



## Loadbalancer

The Traefik ingress controller:
* deploys a `LoadBalancer Service` by default that uses ports 80 and 443, 
* advertises the LoadBalancer Service's External IPs in the Status of Ingress resources it manages.


## FAQ

### Why not NodePort service

The range of valid node ports is `30000-32767`.


