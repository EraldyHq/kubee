% kube-x-logs(1) Version Latest | Return the logs of an app
# NAME

Return the log of pods of an app (workload)


See also [stern](https://github.com/stern/stern) to tail multiple pods and container



## Help


Usage:

Return the logs of pods via an app name

```bash
kube-x-logs <app name>
```
where `app name` is used in the label `app.kubernetes.io/name=<app name>`