

## Auth Host mode

Two criteria must be met for an auth-host to be used:
* Request matches given `cookie-domain`
* `auth-host` is also subdomain of same cookie-domain

In the other mode, you need to register in Dex all callback `redirect_uri`.
* ie https://traefik-bcf52bfa.nip.io/_oauth
* ie https://prometheus-bcf52bfa.nip.io/_oauth

## Setup

```bash
mkdir "charts"
ln -s $(realpath ../cluster) charts/kubee-cluster
mkdir "charts/kubee-dex"
ln -s $(realpath ../dex/Chart.yaml) charts/kubee-dex/Chart.yaml
ln -s $(realpath ../dex/values.yaml) charts/kubee-dex/values.yaml
mkdir "charts/kubee-traefik"
ln -s $(realpath ../traefik/Chart.yaml) charts/kubee-traefik/Chart.yaml
ln -s $(realpath ../traefik/values.yaml) charts/kubee-traefik/values.yaml
```

## Ref

### Within the Traefik pod

https://github.com/thomseddon/traefik-forward-auth/tree/master/examples/traefik-v2/kubernetes/advanced-single-pod

### Separate Pod
https://github.com/thomseddon/traefik-forward-auth/tree/master/examples/traefik-v2/kubernetes/advanced-separate-pod
https://github.com/thomseddon/traefik-forward-auth/tree/master/examples/traefik-v2/kubernetes/simple-separate-pod
