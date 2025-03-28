

## Install

Code: https://github.com/kuberhealthy/kuberhealthy/tree/master/deploy
Docs: https://kuberhealthy.github.io/kuberhealthy/#installation

The equivalent of: 
https://raw.githubusercontent.com/kuberhealthy/kuberhealthy/master/deploy/kuberhealthy-prometheus-operator.yaml


## List the version

```bash
helm repo add kuberhealthy https://kuberhealthy.github.io/kuberhealthy/helm-repos

helm search repo kuberhealthy -l
```


## Note/Next

### Metrics

By going to `https://hostname/metrics`, you will see:
```
# HELP kuberhealthy_running Shows if kuberhealthy is running error free
# TYPE kuberhealthy_running gauge
kuberhealthy_running{current_master="kuberhealthy-f774fb956-fgdtq"} 1
# HELP kuberhealthy_cluster_state Shows the status of the cluster
# TYPE kuberhealthy_cluster_state gauge
kuberhealthy_cluster_state 1
# HELP kuberhealthy_check Shows the status of a Kuberhealthy check
# TYPE kuberhealthy_check gauge
# HELP kuberhealthy_check_duration_seconds Shows the check run duration of a Kuberhealthy check
# TYPE kuberhealthy_check_duration_seconds gauge
# HELP kuberhealthy_job Shows the status of a Kuberhealthy job
# TYPE kuberhealthy_job gauge
# HELP kuberhealthy_job_duration_seconds Shows the job run duration of a Kuberhealthy job
# TYPE kuberhealthy_job_duration_seconds gauge
```