# Self-Signed Cert create with mkcert


This directory contains a self-signed certificate for the domain `kubee.dev`

It's used as [default certificate](https://doc.traefik.io/traefik/https/tls/#default-certificate)

## Directory Listing

This directory contains the following files:

* [rootCA.pem](rootCA.pem) - the RootCA certificate (Should be installed in the browser as trusted Root CA)
* [rootCA-key.pem](rootCA-key.pem) - the RootCA key (Used to sign self-signed domain certificate)
* [kubee.dev+1.pem](kubee.dev+1.pem) - the `kubee.dev` certificate (served by traefik)
* [kubee.dev+1-dev.pem](kubee.dev+1-key.pem) - the `kubee.dev` key (used to encrypt the SSL connection)

## How the rootCA and certificate were made

```bash
export CAROOT=$(realpath .)
mkdir -p $CAROOT
mkcert -install
mkcert "kubee.dev" "*.kubee.dev"
```

## FAQ
### Why dev tld and not local

When testing OAuth, provider may require a valid TLD (Ie Google)
`local` or `lan` is not. `dev` is.
