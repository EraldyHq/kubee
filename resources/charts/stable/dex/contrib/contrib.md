# Dev

## Helm

This chart is an umbrella chart over:
https://charts.dexidp.io/
https://github.com/dexidp/helm-charts

## Bootstrap Helm Charts 

```bash
 kubee helmet update-dependencies dex
```

## FAQ

### Why? No groups for static users

Not supported https://github.com/dexidp/dex/issues/1080

Solution:
* Waiting for the merge
* [kanidm](https://kanidm.github.io/kanidm/stable/examples/kubernetes_ingress.html) implementation (as they state to be low memory)


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


### How to see the token lifetime

* `access token lifetime`: You can see the real value with the exp field of the JWS token.
* `refresh_token_lifetime`: You can see the real value in the cookie lifetime of oauth
