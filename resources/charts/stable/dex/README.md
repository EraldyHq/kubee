# Dex 

## About

`Dex` is an authentication application that supports:
* a local password store
* and connectors to other open identity provider


## Features

By default,
* the admin user is created with its email as login.
* [oauth2-proxy](../oauth2-proxy/README.md) is added as client if enabled
* `kubectl` is added as client if its secret value is not empty

## Cluster Values Example


In your [cluster](../../../docs/site/cluster-creation.md) values file, you need to fill at minimum this values:
```yaml
dex:
  enabled: true
  hostname: 'dex.example.com'
  clients:
    # for traefik forward auth
    oauth2_proxy:
      secret: '${DEX_OAUTH_CLI_SECRET}'
    # for kubectl
    kubectl:
      secret: '${DEX_KUBECTL_CLI_SECRET}'
```

In the cluster `.envrc` file, set the env `DEX_OAUTH_CLI_SECRET` and `DEX_KUBECTL_CLI_SECRET` with your favorite identity store.

Example with `pass`
```bash
export DEX_FORWARD_AUTH_CLI_SECRET
DEX_FORWARD_AUTH_CLI_SECRET=$(pass "cluster_name/dex/forward-auth-cli-secret")
```



## Contrib / Dec

Dev and contrib documentation can be found [here](contrib/contrib.md)
