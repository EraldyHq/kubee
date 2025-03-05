# Contrib/Dev


This helm is based on the [container](https://docs.postalserver.io/other/containers)

Artifact:
* [Compose](https://github.com/postalserver/install/blob/main/templates/docker-compose.v3.yml)
* [Dockerfile](https://github.com/postalserver/postal/blob/main/Dockerfile)


## Bootstrap

```bash
task dep
```

## Note
### Postal Helm Chart
We found [this postal chart](https://github.com/hoverkraft-tech/helm-chart-postal), but it's not yet released
in a correct format.


Does not work:
```bash
# Pull of https://github.com/hoverkraft-tech/helm-chart-postal
helm pull https://github.com/hoverkraft-tech/helm-chart-postal/archive/refs/tags/0.3.1.tar.gz -d charts --untar
# Does not work (expect only one chart, chart is not at the root)
helm pull oci://github.com/hoverkraft-tech/helm-chart-postal -d charts --untar
```

## Config

https://docs.postalserver.io/getting-started/configuration

* [File](https://github.com/postalserver/postal/blob/main/doc/config/yaml.yml)
* [Env](https://github.com/postalserver/postal/blob/main/doc/config/environment-variables.md)

In the [docker image](https://docs.postalserver.io/other/containers#configuration), the `$config-file-root` is `/config`
## Maria Db

https://github.com/MariaDB/mariadb-docker
Backup:
```bash
docker run --volume /backup-volume:/backup --rm mariadb:10.6.15 mariadb-backup --help
```

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

## Installation

### Postal Install

Install the [postal bash cli](https://github.com/postalserver/install/blob/main/bin/postal)
and resources
```bash
sudo git clone https://github.com/postalserver/install /opt/postal/install
sudo ln -s /opt/postal/install/bin/postal /usr/bin/postal
```


### Boostrap
To generate three files in `/opt/postal/config`
```bash
sudo postal bootstrap postal.yourdomain.com
```
```
Latest version is: 3.3.4
=> Creating /opt/postal/config/postal.yml
=> Creating /opt/postal/config/Caddyfile
=> Creating signing private key
```
See:
* [postal installation](https://github.com/postalserver/install/blob/main/examples/postal.v3.yml)
* [posta fulll](https://github.com/postalserver/postal/blob/main/doc/config/yaml.yml)
* [Caddyfile](https://github.com/postalserver/install/blob/main/examples/Caddyfile)

### Initialize/mk user

It will run the [docker-compose.v$MAJOR_VERSION.yml](https://github.com/postalserver/install/blob/main/templates/docker-compose.v3.yml)
to the `/opt/postal/install` dir


## Note

* Postal is a docker based installation. For instance, an upgrade is performed [postal upgrade command line](https://docs.postalserver.io/getting-started/upgrading)
* `postal make-user` pull a big image (491MB around 4 minutes)
* `postal` uses the `/config/postal.yml` conf
* ruby app
