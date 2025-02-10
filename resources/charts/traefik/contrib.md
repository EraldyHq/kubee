# Traefik Contrib

## FAQ: Why our own chart while k3s has a default one

Because it's too slow to update to the last version

## Dev

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
