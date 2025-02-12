

## Setup

```bash
mkdir "charts"
ln -s $(realpath ../traefik) charts/kubee-traefik
ln -s $(realpath ../dex) charts/kubee-dex
```

## Ref
https://github.com/thomseddon/traefik-forward-auth/tree/master/examples/traefik-v2/kubernetes/advanced-separate-pod
https://github.com/thomseddon/traefik-forward-auth/tree/master/examples/traefik-v2/kubernetes/simple-separate-pod
