


## Bootstrap

```bash

mkdir charts/
ln -s $(realpath ../cluster) charts/kubee-cluster
mkdir "charts/kubee-traefik"
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml
mkdir "charts/kubee-cert-manager"
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml

helm repo add mailu https://mailu.github.io/helm-charts/
helm pull https://github.com/Mailu/helm-charts/releases/download/mailu-2.1.2/mailu-2.1.2.tgz -d charts --untar
```

## Note
### Values Example

https://github.com/Mailu/helm-charts/tree/master/mailu#example-valuesyaml-to-get-started
```yaml
domain: mail.mydomain.com
hostnames:
  - mail.mydomain.com
initialAccount:
  domain: mail.mydomain.com
  password: chang3m3!
  username: mailadmin
logLevel: INFO
limits:
  authRatelimit:
    ip: 100/minute;3600/hour
    user: 100/day
  messageSizeLimitInMegabytes: 200
persistence:
  size: 100Gi
  storageClass: fast
secretKey: chang3m3!
```