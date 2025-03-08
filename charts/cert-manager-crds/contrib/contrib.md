

## How do we take the CRDS?

* In the [cert-manager kubee chart](../../cert-manager/README.md), we set the following values
```yaml
cert-manager:
  crds:
    enabled: true
    keep: true
trust-manager:
  crds:
    enabled: true
    keep: true
```
* We template it
```bash
kubee -c beau helmet template --out cert-manager
```
Extracts the CRDS
* [Trust Manager](../templates/crd-trust.cert-manager.io_bundles.yaml)
* [Cert Manager](../templates/crds.yaml)

## Script

```bash
for object_name in $(kubee kubectl get crd -o name | grep cert-manager.io); do
  echo "Patching $object_name"
  kubee kubectl patch "$object_name" --type=merge   -p '{"metadata": { "annotations": {"meta.helm.sh/release-name": "cert-manager-crds"}}}'
done
```

```bash
for object_name in $(kubee kubectl get crd -o name | grep trust.cert-manager.io); do
  echo "Patching $object_name"
  kubee kubectl patch "$object_name" --type=merge   -p '{"metadata": { "annotations": {"meta.helm.sh/release-name": "trust-manager-crds"}}}'
done
```