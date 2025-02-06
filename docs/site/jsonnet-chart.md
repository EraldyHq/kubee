# What is a Jsonnet Kubee Chart

A `Jsonnet Kubee chart` is a chart that has only a [Jsonnet project](jsonnet-project).

It could be then:
* executed only with `Jsonnet`. Example:
```bash
cd jsonnet
rm -rf out && mkdir -p out && jsonnet -J vendor \
  --multi out \
  "main.jsonnet"  \
  --ext-code "values={ kubee: std.parseYaml(importstr \"../../cluster/values.yaml\") }" \
  | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
```
* or added as Jsonnet dependency

You can then add them in GitOps Pull app such as [ArgoCd](https://argo-cd.readthedocs.io/en/stable/user-guide/jsonnet/)
to manage your infrastructure.
