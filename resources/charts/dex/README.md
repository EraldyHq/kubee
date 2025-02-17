# Dex 

## About

`Dex` is an authentication application that supports:
* a local password store
* and connectors to other open identity provider


## Features

By default,
* the admin user is created with its email as login.
* [traefik-forward-auth](../traefik-forward-auth/README.md) is added as client if enabled

## Cluster Values Example


In your [cluster](../../../docs/site/cluster-creation.md) values file, you need to fill at minimum this values:
```yaml
dex:
  enabled: true
  hostname: 'dex.example.com'
  clients:
    traefik_forward_auth:
      secret: '${DEX_TRAEFIK_FORWARD_AUTH_CLI_SECRET}'
```

In the cluster `.envrc` file, set the env `DEX_TRAEFIK_FORWARD_AUTH_CLI_SECRET` with your favorite identity store.

Example with `pass`
```bash
export DEX_TRAEFIK_FORWARD_AUTH_CLI_SECRET
DEX_TRAEFIK_FORWARD_AUTH_CLI_SECRET=$(pass "cluster_name/dex/traefik-forward-auth-cli-secret")
```


## FAQ
### How to I check the installation

Once installed, you should be able to query the discovery endpoint
https://hostname/.well-known/openid-configuration

### Why do I get a 404 Not Found on the hostname

https://hostname/ is not an entrypoint and returns `404`
Check the [discovery file](#how-to-i-check-the-installation) for all endpoints.

### Why do i need to restart after a config change?

The [Helm Chart Roll Deployment](https://helm.sh/docs/howto/charts_tips_and_tricks/#automatically-roll-deployments)
is on the Dex Helm deployment chart.

We can't trick it to apply the checksum on our configuration.

## Contrib / Dec

Dev and contrib documentation can be found [here](contrib/contrib.md)
