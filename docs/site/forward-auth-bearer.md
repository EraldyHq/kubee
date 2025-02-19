# Forward Auth with Bearer

How to verify the `forward-auth-bearer` middleware?

## Steps

### Set the 

* Apply `forward-auth-bearer` middleware on whoami in the cluster file
```yaml
whoami:
  enabled: true
  auth_middleware: 'forward-auth-bearer'
  hostname: 'whoami-xxx.nip.io'
```
* Update
```bash
kubee helmet -c clusertName play whoami
```
* go to https://whoami-xxx.nip.io
* Grab the Authorization Header
```http request
Authorization: Bearer eyJhbGciOiJSU...
```
* Decode the payload at https://jwt.io/. Example:
```json
{
  "iss": "https://dex-xxx.nip.io",
  "sub": "CiQwOGE4Njg0Yi1kYjg4LTRiNzMtOTBhOS0zY2QxNjYxZjU0NjYSBWxvY2Fs",
  "aud": "oauth2-proxy",
  "exp": 1739983694,
  "iat": 1739897294,
  "at_hash": "HtDam6UvwOt6h07X2-BAkw",
  "c_hash": "tv4WJTo8QFFBJdKPQEJHLQ",
  "email": "admin@example.com",
  "email_verified": true,
  "name": "admin"
}
```



