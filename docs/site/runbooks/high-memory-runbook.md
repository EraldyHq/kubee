# High Memory Usage

## Prevention

* Set memory limits on your pods
* Use kubectl describe node to see memory pressure
* Consider enabling memory-based pod eviction policies

## Example

Postgres Archiver taking 16% because the wal archiving was not working.
```
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root     4146498 29.2 34.5 4347184 2739396 ?     Ssl  Jun18 35510:07 /usr/local/bin/k3s server
999        13428  0.0 16.1 1507764 1283196 ?     Ss    2024  15:38 postgres: archiver archiving 000000010000000000000001
```


## Runbook


### Check memory usage
```bash
free -h
top -o %MEM
```

### Check Container Pod Memory Usage

with `crictl`
```bash
sudo crictl stats --output json | jq -r '.stats[] | "\(.attributes.labels."io.kubernetes.pod.name") \(.memory.workingSetBytes.value) \(.attributes.id)"' | sort -k2 -nr | head -10 | column -t
```

### Kill processes by memory usage
```bash
ps aux --sort=-%mem | head -10
kill -9 <high-memory-process-pids>
```

### Use systemd to restart kubelet/docker
```bash
systemctl restart k3s
systemctl restart containerd
```


### Last resort (reboot the node)

```bash
sudo reboot
```