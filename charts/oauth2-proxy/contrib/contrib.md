# Dev Contrib

## Session storage (cookie vs Redis)

https://oauth2-proxy.github.io/oauth2-proxy/configuration/session_storage#cookie-storage

## Charts dir bootstrap

```bash
task dep
```

Pull the original helm chart to get the original Helm template and get the logic
```bash
helm pull https://github.com/oauth2-proxy/manifests/releases/download/oauth2-proxy-7.11.0/oauth2-proxy-7.11.0.tgz -d out --untar
```

## Doc

* Oauth2-proxy Dex Config: https://oauth2-proxy.github.io/oauth2-proxy/configuration/providers/openid_connect
* Example: https://github.com/oauth2-proxy/oauth2-proxy/tree/master/contrib/local-environment/kubernetes
* Traefik Forward Auth example:
  * https://oauth2-proxy.github.io/oauth2-proxy/configuration/integration#forwardauth-with-401-errors-middleware 
  * https://github.com/oauth2-proxy/oauth2-proxy/blob/master/contrib/local-environment/traefik/dynamic.yaml

## How to logout

* Delete the `_oauth2_proxy` cookie
* Or it the [logout endpoint](#test-endpoints)

## Support

### failed to verify certificate: x509

Dex should be installed first so that it got a valid certificate and not the default one of Traefik
```
certificate is valid for ff5fc57a51876b3c153c91cf9855aa80.5598babb9dff56b78b2b0ccea0e125ea.traefik.default, not dex-xxx.nip.io
```

### Why not the helm chart

We don't use the [Helm Chart](https://github.com/oauth2-proxy/manifests) for the following reasons
* We can't take over the checksum of config meaning that if you change a config, you would need to restart
* Bug on service used http in place of https
* We can't use oauth2_proxy as alias: Deployment.apps "oauth2-proxy" is invalid: spec.template.spec.containers[0].name: Invalid value: "oauth2_proxy"
```yaml
- name: oauth2-proxy
  version: 7.11.0
  repository: https://oauth2-proxy.github.io/manifests
  alias: oauth2-proxy
```

### Test 302 Redirect

Works with both
```bash
curl -I  -k https://oauth2-bcf52bfa.nip.io
curl -I  -k https://oauth2-proxy.auth.svc.cluster.local
curl -H "X-Forwarded-For: 10.42.0.220" -H "X-Forwarded-Host: up.nip.io" -H "X-Forwarded-Proto: https" -I  -k https://oauth2-bcf52bfa.nip.io
```
You should get:
```bash
HTTP/2 302 
```
```
https://dex-xxx.nip.io/auth?
approval_prompt=force&
client_id=oauth2-proxy&
redirect_uri=https%3A%2F%2Foauth2-bcf52bfa.nip.io%2Foauth2%2Fcallback&
response_type=code&
scope=openid+email+profile&
state=d5vV1_Hde0ZIYqnOutEOThC5qeEJW_AKFp55SiC6WTk%3A%2F
```

### Test Endpoints
https://oauth2-proxy.github.io/oauth2-proxy/features/endpoints
```bash
curl -I  -k https://oauth2-bcf52bfa.nip.io/ # got 403 lack of permissions
# for nginx
curl -I  -k https://oauth2-bcf52bfa.nip.io/oauth2/auth # got 401 missing or invalid authentication

curl -I  -k https://oauth2-bcf52bfa.nip.io/ready
curl -I  -k https://oauth2-bcf52bfa.nip.io/oauth2/start


curl -H "X-Forwarded-For: 10.42.0.220" -H "X-Forwarded-Host: example.com" -H "X-Forwarded-Proto: https" -I  -k https://oauth2-bcf52bfa.nip.io/oauth2/auth
```

### 403

You get a 403 because you don't have the session cookie
```bash
curl -I  -k https://oauth2-bcf52bfa.nip.io/ 
```



### Why I need to reauthenticate ?

* No scope `offline_access`
* Bad `cookie_refresh` values
 
When the access token is stored in a cookie, the user needs to access the website in the access token lifespan to trigger a refresh before expiration otherwise it would need to re-authenticate.

If we want to have a lower access token lifespan of `10m` and `cookie_refresh_interval: 1m`, we need to use Redis as storage.

Issues:
* https://github.com/oauth2-proxy/oauth2-proxy/issues/1942
* https://github.com/oauth2-proxy/oauth2-proxy/issues/1285
* https://github.com/oauth2-proxy/oauth2-proxy/issues/1836

### Scopes?

* `openid` is mandatory.  Returns the `sub` claim, which uniquely identifies the user. In an ID Token, iss, aud, exp, iat, and at_hash claims will also be present.
* `profile`: returns claims that represent basic profile information, including name, family_name, given_name, middle_name, nickname, picture, and updated_at
* `offline_access` to get a refresh token
* `email`: email
