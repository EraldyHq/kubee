% kubectl-xevent(1) Version Latest | Returns events
# DESCRIPTION

Returns the events of:
* an app (of the pods that belongs to an app). The pods are searched with the label `app.kubernetes.io/name=<app name>`
* or a namespace


# SYNOPSIS


Get the events of an app or namespace

```bash
kubectl-xevent --scope [namespace|app] 
```
where `app name` is
* optional if you run the command in the app directory (default to: `$KUBE_APP_NAME`)
* mandatory otherwise


