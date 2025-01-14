# Dex (Work in Progress)

## About

Dex is an OpenID front ends (portal) to other identity providers.

It permits to authenticate a user with openId to other providers that does not support it


## AuthZ

Authz is limited to a group (org in github, group in ldap, ...)

In connector, you have org constraints such as: A user MUST be a member of the following org to authenticate with dex.

## Example / Tuto

* https://github.com/dexidp/dex/tree/master/examples/k8s
* https://github.com/coderanger/traefik-forward-auth-dex


## Forward Auth

* [Simple](https://github.com/thomseddon/traefik-forward-auth/tree/master/examples/traefik-v2/kubernetes/simple-separate-pod)
* [Advanced](https://github.com/thomseddon/traefik-forward-auth/tree/master/examples/traefik-v2/kubernetes/advanced-separate-pod)


