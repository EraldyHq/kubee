


## Helm Schema

We filter on the current chart
because if we change a schema of a dependency, 
we need to regenerate all dependent schema,
and it does not work for now.
```bash
helm schema --helm-docs-compatibility-mode -k additionalProperties --dependencies-filter kubee-mailpit
```
Why?
* because empty default value are seen as required and some dependent chart such as Traefik are out of control

To make it work, we need to create a script that make a custom call for each chart.

## Helm Schema: no schema found error

Just FYI.
With the error:
```
If you'd like to use helm-schema on your chart dependencies as well, you have to build and unpack them before.
You'll avoid the "missing dependency" error message.
```

What they mean is when you have all your chart dependency in the `charts/`, you need:
```bash
# go where your Chart.lock/yaml is located
cd <chart-name>

# build dependencies and untar them
helm dep build
ls charts/*.tgz |xargs -n1 tar -C charts/ -xzf
```
