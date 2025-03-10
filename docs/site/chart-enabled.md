# Chart Enabled Property

Every [app kubee chart](app-chart.md) has an `enabled` property.

This property tells if the app is installed or will be installed in the [cluster](cluster.md).


> [!Info]
> The `enabled` property comes from the [Helm best practices](https://helm.sh/docs/chart_best_practices/dependencies/#conditions-and-tags)

## Usage

It's used to:
* conditionally applied manifest. If there is no grafana, don't install the dashboard
* cluster bootstrapping (ie install all charts at once)
