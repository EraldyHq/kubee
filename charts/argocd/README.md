# ArgoCd


## About
This chart is a [Helm-x Chart](../../../docs/bin/kubee-helmet) that:
* executes [a standard installation with cluster-admin access](https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/#non-high-availability)
* and configure optionally:
  * an [Ingress](templates/resources/argocd-ingress.yaml)
  * a [git repo](templates/resources/argocd-secret-repo.yaml)
  * a [github webhook](templates/resources/argocd-secret-external.yaml)
  * [mailing and a on-deployed notifications](templates/patches/argocd-notifications-cm.yaml)
  * the [ArgoCd Monitoring mixin](https://monitoring.mixins.dev/argo-cd-2/) (Prometheus Rules and Dashboards)
* [avoid CPU and memory spike on Sync by default](docs/argocd-cpu-memory-spikes.md)


## How to

### Test/Check values before installation

With Helm-x For instance, to check the [repo creation](templates/resources/argocd-secret-repo.yaml)
```bash
export BASHLIB_ECHO_LEVEL=4;
kubee helmet -c clusterName template argocd | grep 'name: argocd-secret-repo' -A 2 -B 11
```


## Dev / Contrib


[](contrib.md)