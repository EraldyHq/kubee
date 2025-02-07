% kubee-k3s(1) Version Latest | k3s specific scripts
# DESCRIPTION


K3s specific scripts that should be used on the server


# SYNOPSIS

This script should be executed on the server

```bash
kubee-k3s command args
```
where: command may be:
  * `certs_expiration` : Print the k3s certificates and their expiration date
  * `cert_print` : Print a single k3s pem file
  * `cert_secret_print` : Print the k3s-serving kubernetes TLS cert secret

All certs should be relative name (This script adds the k3s tls directory: /var/lib/rancher/k3s/server/tls)

