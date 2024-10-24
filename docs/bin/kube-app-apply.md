# kube-app-apply

Run kustomize apply to an app from anywhere

## Overview

With this script, you can apply kustomize to an app that is located below the directory `$KUBE_APP_HOME`
You can then run it from anywhere (any working directories)



## Help

Usage:

```bash
kube-app-apply <app name>
```

Note:
* The `$KUBE_APP_HOME` environment variable should be set to a directory that
  has kustomize applications as subdirectories
* The script will run
```bash
kubectl apply -k $KUBE_APP_HOME/<app name>
```
