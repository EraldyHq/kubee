# Contrib/Dev


This helm is based on the [container](https://docs.postalserver.io/other/containers)

Artifact:
* [Compose](https://github.com/postalserver/install/blob/main/templates/docker-compose.v3.yml)
* [Dockerfile](https://github.com/postalserver/postal/blob/main/Dockerfile)


## Bootstrap

```bash
mkdir charts/
ln -s $(realpath ../cluster) charts/kubee-cluster
mkdir charts/kubee-cluster-0.0.1.tgz
mkdir "charts/kubee-traefik"
mkdir charts/kubee-traefik-0.0.1.tgz
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml
mkdir "charts/kubee-cert-manager"
mkdir charts/kubee-cert-manager-0.0.1.tgz
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml


helm pull  oci://registry-1.docker.io/bitnamicharts/mariadb --version 20.4.1 -d charts --untar

# Pull of https://github.com/hoverkraft-tech/helm-chart-postal
# Does not work (Chart is not at the root)
helm pull https://github.com/hoverkraft-tech/helm-chart-postal/archive/refs/tags/0.3.1.tar.gz -d charts --untar
# Does not work (expect only one chart, chart is not at the root)
helm pull oci://github.com/hoverkraft-tech/helm-chart-postal -d charts --untar
```

## Maria Db

https://mariadb.com/kb/en/kubernetes-and-mariadb/
https://mariadb.com/kb/en/kubernetes-operators-for-mariadb/



## Helm

The helm is not yet finished: https://github.com/postalserver/install/pull/20
and pretty poor

We didn't go with it.
```bash
mkdir charts
git remote add -f postal-chart https://github.com/dmitryzykov/postal-install.git
git subtree add --prefix=resources/charts/stable/postal/charts/postal postal-chart main --squash -- helm/postal
mkdir charts/postal-1.0.0.tgz
```