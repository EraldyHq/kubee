% kubee-helm-post-renderer(1) Version Latest | A Helm Post renderer
# NAME

`kubee-helm-post-renderer` is a  [helm post renderer](https://helm.sh/docs/topics/advanced/#post-rendering)
that adds support for:
* `Jsonnet` 
* and `kustomize`

# SYNOPSIS

A post renderer to integrate `kustomize` and `jsonnet`
```bash
kubee-helm-post-renderer appDirectory valuesPath namespace output_dir
```

where:

* `KUBEE_CHART_DIRECTORY` is the directory of the app to install
* `KUBEE_VALUES_FILE` is the path to the values file
* `NAMESPACE` is the installation namespace
* `OUTPUT_DIR` is the output dir (Helm)

Note: Helm:
* pass the templates output via stdin
* will not print any output if no error occurs (even with the --debug flag)

# HOW IT WORKS

- if a `jsonnet` directory exists at the root of the chart directory
  - if a `jsonnetfile.json` is present, the `jsonnet bundler` is executed to fetch dependencies
  - the `jsonnet` files present in the `jsonnet` directory are executed 
  - the output are added to the Helm templates
- if a `kustomization.yml` is present at the root of the chart directory
  - the environment variables present in `kustomization.yml` are substituted
  - the templates are rendered
  - `kustomize` is applied
  - the output is added to the Jsonnet templates if present

# JSONNET

See [kubee jsonnet-project](../site/jsonnet-project)

# KUSTOMIZATION

