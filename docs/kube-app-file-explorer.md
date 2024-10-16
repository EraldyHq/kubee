# kube-app-file-explorer

Explore the volume of a pod via SCP/SFTP

## Overview

This script:
* starts a sshd privilege pod
* mount the volumes of the app at `/volumes`
* so that you can use an SCP/SFTP file editor

See also [kubectl-sshd](https://github.com/ottoyiu/kubectl-sshd)
if you can't start a privileged pod



## Help

Usage:

Explore the volume of a pod via SCP/SFTP

This command will start a temporary SSH pod where the volume of the app pod have been mapped to `/volumes`

```bash
kube-app-file-explorer <app name> <public key>
```
where:
* `app name` is used in the label `app.kubernetes.io/name=<app name>` to select the pod
* `public key` is the path of the public key that should be authorized to connect as `root` (Default to `KUBE_PUBLIC_KEY` env)
