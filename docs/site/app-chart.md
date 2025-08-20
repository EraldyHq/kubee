# Kubee App Chart


An `app chart` is a [kubee chart](kubee-helmet-chart.md) that install/upgrade an application.

## Helm Wrapper

An `app chart`
  * create a [helm chart](https://helm.sh) dynamically with:
    * helm templating, 
    * jsonnet
    * kustomize
  * and install/upgrade it  

`App Charts` are therefore generated `Helm` Charts.

You:
* use any [Helm command](https://helm.sh/docs/helm/helm/) to manage them
* except for the [installation and upgrade](#installation--upgrade)

## Operation/Command


### Installation / Upgrade

They are installed with `kubee helmet`.

Once you have added or modified the app chart to your [cluster values](cluster-values.md) file, you
can install or update it via the following command:
```bash
kubee --cluster cluster-name helmet play chart-name
```

Example for the `kubernetes-dashboard` chart
```bash
kubee --cluster cluster-name helmet play kubernetes-dashboard
```

### List


Example:
* Using helm to list all charts
```bash
helm list --all-namespaces
# Using kubee
kubee --cluster cluster-name helm list --all-namespaces 
```
* Using helm to list the charts of a namespace
```bash
helm list -n namespace
# Using kubee
kubee --cluster cluster-name helm list -n namespace
```

### Uninstall/Delete


Using helm to delete a chart
```bash
helm uninstall -n namespace chart_name
# Using kubee
kubee --cluster cluster-name helm uninstall -n namespace chart_name 
```

