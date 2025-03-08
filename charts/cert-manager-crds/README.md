# Kubee Cert Manager CRDS


This kubee chart installs the CRD of the cert manager.

It's a dependency of the [kubee cert manager chart](../cert-manager/README.md)

## Features

### resource-policy: keep

We add a `helm.sh/resource-policy: keep` to avoid any bad deletion.
