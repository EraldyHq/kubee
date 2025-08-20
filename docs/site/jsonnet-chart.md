# What is a Jsonnet Helmet Chart

A `Jsonnet Helmet chart` is a [Helmet app chart](app-chart.md) that has only
a [Jsonnet project](jsonnet-project.md).


## Features

It could be then:

* executed only with `Jsonnet`. Example:

```bash
cd jsonnet
rm -rf out && mkdir -p out && jsonnet -J vendor \
  --multi out \
  "main.jsonnet"  \
  --ext-code "values=std.parseYaml(importstr \"../../cluster/values.yaml\")" \
  | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}
```

* or added as Jsonnet dependency
