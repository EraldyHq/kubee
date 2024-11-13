# kube-bash

Start a shell in a pod

## Overview

Connect with a shell (bash by default) to a pod by app name



## Help

Usage:

Get a shell into a pod or your cluster

```bash
kube-app-bash --shell <shell name> <app name>
```

where:
* `app name` default to the env `KUBE_APP_NAME` may be:
    * an app name (used with the label `app.kubernetes.io/name=<app name>` select the target pod)
    * or `busybox` to run a standalone busybox pod
* `shell name` may be:
  * a shell path (ie `bash`, `sh`, `bin/bash`)
  * or `ephemeral` to add busybox as an ephemeral container if your container has no shell

