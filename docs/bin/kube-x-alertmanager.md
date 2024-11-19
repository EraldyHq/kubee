% kube-x-alertmanager(1) Version Latest | Alert Manager API Cli
# DESCRIPTION


`kube-x-alertmanager` is a [alert client](https://prometheus.io/docs/alerting/latest/clients/)
that performs request against the [alert manager api](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/prometheus/alertmanager/main/api/v2/openapi.yaml)

# NOTE
Clients are expected to continuously re-send alerts as long as they are still active (usually on the order of 30 seconds to 3 minutes)
An alert is considered as resolved if it has not been updated/resend after the `resolve_timeout` configuration.
```yaml
resolve_timeout: 30m
```

# SYNOPSIS

${SYNOPSIS}

