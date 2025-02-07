% kubeeshell(1) Version Latest | Start a shell in a pod


# DESCRIPTION

Start a shell in a pod

Connect with a shell (bash by default) to a pod by app name


# busybox

This commands supports busybox as target to create a container.

# SYNOPSIS


Get a shell into your application pod or your cluster with busybox

```bash
kubee app shell [--shell|-s shellName <app name>
```

where:

* `app name` may be:
    * an app name
    * or `busybox` to run a standalone busybox pod
* `--shell|-s shell name` may be:'
  * a shell path (ie `bash`, `sh`, `bin/bash`)
  * or `ephemeral` to add busybox as an ephemeral container if your container app has no shell
