# Dev Contrib


## Charts dir bootstrap

```bash
mkdir "charts"
ln -s $(realpath ../kubee) charts/kubee
mkdir "charts/kubee-dex"
ln -s $(realpath ../dex/Chart.yaml) charts/kubee-dex/Chart.yaml
ln -s $(realpath ../dex/values.yaml) charts/kubee-dex/values.yaml
mkdir "charts/kubee-prometheus"
ln -s $(realpath ../prometheus/Chart.yaml) charts/kubee-prometheus/Chart.yaml
ln -s $(realpath ../prometheus/values.yaml) charts/kubee-prometheus/values.yaml
mkdir "charts/kubee-cert-manager"
ln -s $(realpath ../cert-manager/Chart.yaml) charts/kubee-cert-manager/Chart.yaml
ln -s $(realpath ../cert-manager/values.yaml) charts/kubee-cert-manager/values.yaml
```

Pull the original helm chart to get the original Helm template and get the logic
```bash
helm pull https://github.com/oauth2-proxy/manifests/releases/download/oauth2-proxy-7.11.0/oauth2-proxy-7.11.0.tgz -d out --untar
```

## Doc

Oauth2-proxy Dex Config: https://oauth2-proxy.github.io/oauth2-proxy/configuration/providers/openid_connect
Example: https://github.com/oauth2-proxy/oauth2-proxy/tree/master/contrib/local-environment/kubernetes

## Support

### failed to verify certificate: x509

Dex should be installed first so that it got a valid certificate and not the default one of Traefik
```
certificate is valid for ff5fc57a51876b3c153c91cf9855aa80.5598babb9dff56b78b2b0ccea0e125ea.traefik.default, not dex-xxx.nip.io
```

### Why not the helm chart

We don't use the [Helm Chart](https://github.com/oauth2-proxy/manifests) for the following reasons
* We can't take over the checksum of config meaning that if you change a config, you would need to restart
* Bug on service used http in place of https
* We can't use oauth2_proxy as alias: Deployment.apps "oauth2-proxy" is invalid: spec.template.spec.containers[0].name: Invalid value: "oauth2_proxy"
```yaml
- name: oauth2-proxy
  version: 7.11.0
  repository: https://oauth2-proxy.github.io/manifests
  alias: oauth2-proxy
```

### 403

You get a 403 because you don't have the session cookie
```bash
curl -I  -k https://oauth2-bcf52bfa.nip.io/ 
```