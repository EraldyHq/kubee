## How to develop

We created the [update-grafana-crds](./update-grafana-crds) script
to develop/update the chart development automatically.

```bash
./update-grafana-crds
```

## CRD Note

One by release: https://github.com/grafana/grafana-operator/releases/download/v5.15.1/crds.yaml
To avoid issues due to outdated or missing definitions, run the following command before updating an existing installation:
```bash
kubectl apply --server-side --force-conflicts -f https://github.com/grafana/grafana-operator/releases/download/v5.15.1/crds.yaml
```