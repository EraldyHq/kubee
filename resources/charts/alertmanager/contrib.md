# Contrib / Dev



## Steps

* Download the dependency scripts with this script: [script](utilities/dl-alertmanager-dependency-scripts)
* Jb
```bash
jb init
jb install github.com/prometheus/alertmanager/doc/alertmanager-mixin@v0.28.0
jb install github.com/kubernetes-monitoring/kubernetes-mixin@af5e898 # last main commit
```
* Run
```bash
# with jsonnet
rm -rf jsonnet/multi/manifests && mkdir -p jsonnet/multi/manifests/setup && jsonnet -J vendor --multi jsonnet/multi/manifests "jsonnet/multi/alertmanager.jsonnet" --ext-code "values={ kubee: std.parseYaml(importstr \"../../kubee/values.yaml\") }" | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
# with helm_x to test a cluster values
export BASHLIB_ECHO_LEVEL=4 # debug to keep the generated manifests
kubee-chart --cluster clusterName template alertmanager > /tmp/all.yml
# to test only helm template with -s (show-only)
helm template -s templates/alertmanager-ingress.yaml --set 'kubee.hostname=alert.com' . | yq
```

## How 
### How does Alert Manager config is searched

Prometheus operator searches:
* an `alertmanager.yaml` from the secret `alertmanager-<alertmanager-name>`
* all other `AlertConfig CRDs`

## Support

### field smtp_password not found in type config.plain

It means that the `smtp_password` is not a known configuration.
Check the conf here: https://prometheus.io/docs/alerting/latest/configuration/#file-layout-and-global-settings