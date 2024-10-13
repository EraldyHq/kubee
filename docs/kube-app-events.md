# kube-app-events

Returns the events of an app

## Overview

Returns the events of an pods that belongs to an app
The pods are searched with the label `app.kubernetes.io/name=<app name>`



## Help


Get the events of an app

```bash
kube-app-events [app name]
```
where `app name` is
* optional if you run the command in the app directory (default to: `$KUBE_APP_NAME`)
* mandatory otherwise
