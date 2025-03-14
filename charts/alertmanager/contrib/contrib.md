# Contrib / Dev



## Boostrap

* Download the dependency scripts with this script: [script](dl-dependency-scripts)

## How 
### How does Alert Manager config is searched

Prometheus operator searches:
* an `alertmanager.yaml` from the secret `alertmanager-<alertmanager-name>`
* all other `AlertConfig CRDs`

## Support

### field smtp_password not found in type config.plain

It means that the `smtp_password` is not a known configuration.
Check the conf here: https://prometheus.io/docs/alerting/latest/configuration/#file-layout-and-global-settings