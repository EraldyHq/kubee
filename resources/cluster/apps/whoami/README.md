# Whoami WebSite

## About

`Whoami` is an app that permits to debug traefik.

## Install SubChart

* Download dependency:
```bash
helm dependency update # update the dependencies (ie kube-x if changed version or not)
```
* Test
```bash
helm lint
helm template -s templates/deployment.yaml .
```