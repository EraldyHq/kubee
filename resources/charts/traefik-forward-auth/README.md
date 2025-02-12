# Traefik Forward Auth


This kubee chart will install [traefik-forward-auth](https://github.com/thomseddon/traefik-forward-auth).
to forward authentication of infrastructure app to the [dex auth provider](../dex/README.md)

# Prerequisite

* The [dex chart](../dex/README.md) should be installed

# How to enable it on Traefik

Once installed, you can then change the [default auth middleware of Traefik]() to `forward-auth`
to forward the authentication.