

## Setup

```bash
mkdir "charts"
ln -s $(realpath ../kubee) charts/kubee
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
