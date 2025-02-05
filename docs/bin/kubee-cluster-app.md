# Kube App



## Installation Graph

* Secret (used everywhere)
* Ingress
* apps


## FAQ: Why not multiple sub-chart by umbrella chart?

SubChart cannot by default installed in another namespace than the umbrella chart.
This is a [known issue with helm and subcharts](https://github.com/helm/helm/issues/5358)

That's why:
* the unit of execution is one sub-chart by umbrella chart
* `kubee` is a common sub-chart of all umbrella chart
* this is not one `kubee` umbrella chart with multiple sub-charts 




