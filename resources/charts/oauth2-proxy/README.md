# Kubee Chart of Oauth2 Proxy

## About
A Kubee Chart installation of [Oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/installation)
configured as:
* a middleware to add authentication with Traefik forward auth.
* with [Dex](../dex/README.md)


![](https://oauth2-proxy.github.io/oauth2-proxy/assets/images/simplified-architecture-2a6ee6443dc78a5a28dfdb49f07f981e.svg)

## Installation

* [Dex](../dex/README.md) should be installed first as Oauth2 Proxy needs get the reach the Dex discovery endpoint to start



## Support

### failed to verify certificate: x509

Dex should be installed first so that it got a valid certificate and not the default one of Traefik
```
certificate is valid for ff5fc57a51876b3c153c91cf9855aa80.5598babb9dff56b78b2b0ccea0e125ea.traefik.default, not dex-xxx.nip.io
```
