# kube-bash

Start bash in a pod via bash

## Overview

Connect with a shell (bash by default) to a pod by app name



## Help

Usage:

Get a shell into a pod or your cluster

```bash
kube-app-bash <app name> <shell name>
```

where:
* `app name` may be:
    * an app name (used with the label `app.kubernetes.io/name=<app name>` select the target pod)
    * or `busybox` to run a standalone busybox pod
* `shell name` may be:
  * a shell path (ie `bash`, `sh`, `bin/bash`)
  * or `ephemeral` to start busybox as an ephemeral container
