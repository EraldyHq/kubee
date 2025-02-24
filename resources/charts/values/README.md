# Kubee Values


A utility chart to get the result of merged values files.

## Why ?

There is no option or flag to get the merged values in Helm.

The actual trick is to create a dedicated chart with:
* [this template](templates/values.yaml)
* containing this template code `{{ toYaml .Values }}`

## Usage

```bash
helm template fake-release-name . -f values1.yaml -f values2.yaml -f values3.yaml
```

## Ref

Issues:
* https://github.com/helm/helm/issues/6772
* https://github.com/helm/helm/issues/12007

Helm example from issue: https://github.com/helm/helm/files/11402407/mergevalues.tar.gz
`/files` are just a file id used to store file from issues.
