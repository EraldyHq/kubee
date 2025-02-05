# External Secret Sub-Chart

## About

This chart install [external secrets](https://external-secrets.io/latest/)
and optionally configure [vault](../vault/README.md) as secret store if
  * vault is enabled
  * and an api token is provided

## Install

```bash
kubee-helx --cluster clusterName install external-secrets
# example with a cluster name of kubee-ssh
kubee-helx --cluster kubee-ssh install external-secrets
```

## Test/Check values before installation

To check the [vault cluster store creation](templates/cluster-secret-store-vault.yaml)
```bash
kubee-helx -c kubee-ssh template external-secrets | grep 'cluster-secret-store-vault.yaml' -A 30
```

## Test/Check after installation

* Chart are installed
```bash
helm list -n external-secrets
kubee-helm list -n external-secrets
```
```
NAME                    NAMESPACE               REVISION        UPDATED                                 STATUS          CHART                                   APP VERSION
external-secrets        external-secrets        1               2025-01-08 15:49:54.444756277 +0100 CET deployed        kubee-external-secrets-0.0.1           0.10.7     
external-secrets-crds   external-secrets        1               2025-01-08 15:50:51.600676296 +0100 CET deployed        kubee-external-secret-crds-0.0.1       0.10.7
```
* Status of the vault cluster store manifest (if installed)


## Conf

* Vault: The conf needs a secret (vault api token) to read the vault secrets. See [external-secret in kubee values.yaml](../kubee/values.yaml)


## Note
### Dev / Contrib

* Add repo and download dependency:
```bash
helm dependency update
```
* Verify
```bash
helm lint
```
* Install
```bash
KUBEE_APP_NAMESPACE=external-secrets
helm upgrade --install -n $KUBEE_APP_NAMESPACE --create-namespace external-secrets .
# with kubee
kubee-helm upgrade --install --create-namespace external-secrets .
```



## Support

### Error: failed to delete release: external-secrets

```
client.go:486: 2024-11-27 10:02:49.465682846 +0100 CET m=+1.116866923 [debug] Starting delete for "secretstore-validate" ValidatingWebhookConfiguration
uninstall.go:124: 2024-11-27 10:02:49.504973529 +0100 CET m=+1.156157606 [debug] uninstall: 
  Failed to delete release: [Internal error occurred: failed calling webhook "validate.clustersecretstore.external-secrets.io": 
  failed to call webhook: Post "https://external-secrets-webhook.external-secrets.svc:443/validate-external-secrets-io-v1beta1-clustersecretstore?timeout=5s": service "external-secrets-webhook" not found]
Error: failed to delete release: external-secrets
```
Yeah:
* https://external-secrets-webhook.external-secrets.svc is bad, 
* it should be https://external-secrets-webhook.external-secrets.svc.cluster.local

