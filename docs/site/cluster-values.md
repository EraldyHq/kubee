# Cluster Values File


The Cluster values file:
* is a file named `values.yaml` 
* located in a [cluster directory](cluster-creation.md) 
* that contains the chart configuration for the whole cluster.


## Example

A cluster with Cert manager, Traefik and Kubernetes Dashboard
```yaml
cert_manager:
  enabled: true
  # The issuer used in all certificate request of kube-x.
  issuer_name: 'letsencrypt-prod'
traefik:
  enabled: true
  hostname: 'traefik-bcf52bfa.nip.io'
kubernetes_dashboard:
  enabled: true
  # The external DNS
  hostname: 'kube-bcf52bfa.nip.io'
```

## Structure

The Cluster values files has one top node for each [kubee helmet chart](kubee-helmet-chart.md)
that contains the [helmet chart configuration](kubee-helmet-chart.md#values-file)

Each chart top node should at least have the `enabled` property set to `true`
if the Chart should be installed.

