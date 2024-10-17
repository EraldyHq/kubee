# kube-k3s

k3s specific scripts

## Overview

K3s specific scripts that should be used on the server



## Help

Usage:


```bash
kube-k3s command args
```
where: command may be:
  * `certs_expiration` : Print the certificates and their expiration date
  * `cert_print` : Print a single pem file
  * `cert_secret_print` : Print a kubernetes TLS cert secret

All certs should be relative name (This script adds the directory: /var/lib/rancher/k3s/server/tls)
