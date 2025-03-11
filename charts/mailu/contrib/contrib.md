


## Bootstrap

```bash
task dep
```

## Note
### Values Example

https://github.com/Mailu/helm-charts/tree/master/mailu#example-valuesyaml-to-get-started
```yaml
domain: mail.mydomain.com
hostnames:
  - mail.mydomain.com
initialAccount:
  domain: mail.mydomain.com
  password: chang3m3!
  username: mailadmin
logLevel: INFO
limits:
  authRatelimit:
    ip: 100/minute;3600/hour
    user: 100/day
  messageSizeLimitInMegabytes: 200
persistence:
  size: 100Gi
  storageClass: fast
secretKey: chang3m3!
```