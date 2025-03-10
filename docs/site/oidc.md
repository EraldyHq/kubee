


## Test OIDC

The JWS Token should have the `Kubernetes` audience to log in to the Kubernetes API.

Example: Whoami Token as seen in https://jwt.io
```json
{
  "iss": "https://dex-xxx.nip.io",
  "sub": "CiQwOGE4Njg0Yi1kYjg4LTRiNzMtOTBhOS0zY2QxNjYxZjU0NjYSBWxvY2Fs",
  "aud": [
    "kubernetes",
    "oauth2-proxy"
  ],
  "exp": 1740245547,
  "iat": 1740159147,
  "azp": "oauth2-proxy",
  "at_hash": "k2g1Ifln8kKAJdZ1QK6ZLw",
  "c_hash": "mgS6xLuU0uIrsAFA5dB8uA",
  "email": "foo@example.com",
  "email_verified": true,
  "name": "foo"
}
```
