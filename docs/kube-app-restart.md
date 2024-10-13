

## Help


Restart an app

```bash
kube-app-restart [app name]
```
where `app name` is
* optional if you run the command in the app directory (default to: `$KUBE_APP_NAME`)
* mandatory otherwise

Note:
* The `app namespace` is set by direnv via the `$KUBE_APP_NAMESPACE` env
* The executed command is:
```bash
kubectl rollout restart -n $KUBE_APP_NAMESPACE deployment $KUBE_APP_NAME
```
