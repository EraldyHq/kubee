# High CPU

## About


k3s is the parent process for all containers, 
you need to drill down to see which pod/container is actually consuming resources

## CPU Analytics

Since k3s runs everything on the host (not in VMs), the problematic process will show up directly in top.

### Top


Get access to the node
  * Ssh 
  * Start a container
```bash
kubectl debug node/<node-name> -it --image=ubuntu
# Then inside the container:
chroot /host
```

Then start top
```bash
top
# or
top -c -o %CPU
```

or
```bash
htop
```

#### Load average


The load of 3.01 per core is quite high - typically you want it below 1.0 per core. 
Since it's sustained over 15 minutes, this suggests an ongoing issue rather than a temporary spike.
A load of 3.01 per core suggests either CPU-bound processes or significant I/O blocking.

Example:
* normal (usually sit between about 1.0 and 3.0.)
```
load average: 0.87, 1.56, 1.35
```
* high (around 8-9, getting worse over time)
```
load average: 5.40, 10.09, 11.80
```

A high load average can be caused by:
* Memory thrashing: System is constantly swapping because you have no swap space and RAM is 95%+ full
* Processes are blocking waiting for memory/I/O
 
#### Swapping ? kswapd0, wa

* If `kswapd0` is using CPU, this kernel process swaps memory to disk when RAM is full
* High I/O wait (`wa`): 9.7% - the system is waiting on disk I/O (memory swapping)

### Memory

```bash
MiB Mem :   7750.7 total,    403.6 free,   5580.2 used,   2156.9 buff/cache
```
Memory exhausted?, no : Only 132 MB free out of 7.7 GB total

## Other CPU analysis


```bash
# Check resource usage of pods on that node
kubectl top pods --all-namespaces --sort-by=cpu --field-selector spec.nodeName=kube-server-01.eraldy.com
# Script failed use the global debug flag ie (kubee --debug kubectl) to get more information

ps aux --sort=-%cpu | head -20

```





## K3s-server as Top process

k3s as highest CPU user per top

k3s-server using 232% CPU and 2.1 GB RAM - this is abnormally high

Check the log for any error
```bash
journalctl -u k3s -f --since "15 minutes ago"
# or ?
journalctl -e -u k3s
```

Check the database size [for vaccum / compaction error](../k3s-datastore.md)

Similar: https://github.com/k3s-io/k3s/discussions/10306


