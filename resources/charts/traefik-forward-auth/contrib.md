

## Setup

```bash
mkdir "charts"
ln -s $(realpath ../kubee) charts/kubee
mkdir "charts/kubee-dex"
ln -s $(realpath ../dex/Chart.yaml) charts/kubee-dex/Chart.yaml
ln -s $(realpath ../dex/values.yaml) charts/kubee-dex/values.yaml
```

## Ref
https://github.com/thomseddon/traefik-forward-auth/tree/master/examples/traefik-v2/kubernetes/advanced-separate-pod
https://github.com/thomseddon/traefik-forward-auth/tree/master/examples/traefik-v2/kubernetes/simple-separate-pod
