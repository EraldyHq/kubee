# kube-bash

Start bash in a pod via bash

## Overview

Connect with a shell (bash by default) to a pod by app name



## Help

Usage:

```bash
kube-bash <app name>
```

Note: The label `app.kubernetes.io/name=<app name>` is used to select the target pod
