# kube-app-restart

Restart a workload (deployment/statefulset) by app name

## Overview

Restart a workload by app name
A deployment or statefulset is searched with the label `app.kubernetes.io/name=<app name>`
and restarted if found with the command `kubectl rollout restart`



## Help


Restart an app (ie rollout restart a deployment or statefulset)

```bash
kube-x-restart [app name]
```
where `app name` is
* optional if you run the command in the app directory (default to: `$KUBE_APP_NAME`)
* mandatory otherwise
