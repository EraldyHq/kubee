# Dex 

## About

Dex is an OpenID front ends (portal) to other identity providers.

It permits to authenticate a user with openId to other providers that does not support it



## Discovery

Once installed, you should be able to query the discovery endpoint
https://hostname/.well-known/openid-configuration

## 404 Not Found

https://hostname/ is not an entrypoint and returns `404`
Check the [discovery file](#discovery) for all endpoints.

## Contrib / Dec

See [Contrib](contrib.md)