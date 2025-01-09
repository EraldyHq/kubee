# Self-Signed Cert create with mkcert


This directory contains a self-signed certificate for the domain `kube-x.dev`

It's used as [default certificate](https://doc.traefik.io/traefik/https/tls/#default-certificate)

## Directory Listing

This directory contains the following files:

* [rootCA.pem](rootCA.pem) - the RootCA certificate (Should be installed in the browser as trusted Root CA)
* [rootCA-key.pem](rootCA-key.pem) - the RootCA key (Used to sign self-signed domain certificate)
* [kube-x.dev+1.pem](kube-x.dev+1.pem) - the `kube-x.dev` certificate (served by traefik)
* [kube-x.dev+1-dev.pem](kube-x.dev+1-key.pem) - the `kube-x.dev` key (used to encrypt the SSL connection)

## How the rootCA and certificate were made

```bash
export CAROOT=$(realpath .)
mkdir -p $CAROOT
mkcert -install
mkcert "kube-x.dev" "*.kube-x.dev"
```

## FAQ
### Why dev tld and not local

When testing OAuth, provider may require a valid TLD (Ie Google)
`local` or `lan` is not. `dev` is.
