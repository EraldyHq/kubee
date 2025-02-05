% kubee-alertmanager(1) Version Latest | Alert Manager API Cli
# DESCRIPTION


`kubee-alertmanager` is a [alert client](https://prometheus.io/docs/alerting/latest/clients/)
that performs request against the [alert manager api](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/prometheus/alertmanager/main/api/v2/openapi.yaml)

# NOTE
Clients are expected to continuously re-send alerts as long as they are still active (usually on the order of 30 seconds to 3 minutes)
An alert is considered as resolved if it has not been updated/resend after the `resolve_timeout` configuration.
```yaml
resolve_timeout: 30m
```

# ENV

* `KUBEE_ALERT_MANAGER_URL`: the url of Alert Manager
* `KUBEE_ALERT_MANAGER_BASIC_AUTH_PASS_USER`: the path in [pass](https://www.passwordstore.org/) to the basic auth user
```bash
# ie this command should return the user
pass $KUBEE_ALERT_MANAGER_BASIC_AUTH_PASS_USER
```
* `KUBEE_ALERT_MANAGER_BASIC_AUTH_PASS_PASSWORD`: the path in [pass](https://www.passwordstore.org/) to the basic auth password
```bash
# ie this command should return the password
pass $KUBEE_ALERT_MANAGER_BASIC_AUTH_PASS_PASSWORD
```

# SYNOPSIS

```bash
kubee-alertmanager [--url alert-manager-url] path method [name]
```

where:
* `path` can be all [path apis](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/prometheus/alertmanager/main/api/v2/openapi.yaml)
* `method` can be:
  * `post` - post (only for alerts)
  * `get`  - get (no filtering for now)
* `name` is a mandatory alert name to post a test alerts
* `--url|-u` defines the Alert Manager URL (`http://localhost:9093`), default to `KUBEE_ALERT_MANAGER_URL`

# Example
To trigger a test alert:
```bash
kubee-alertmanager alerts post test
```

