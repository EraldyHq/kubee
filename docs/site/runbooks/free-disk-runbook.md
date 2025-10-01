# Free 


## Analysis disk usage

```bash
sudo df -h
sudo du -h --max-depth=2 /var | sort -hr | head -20
sudo du -h --max-depth=2 /var/lib/rancher | sort -hr | head -20
```
```
58G     /var/lib
58G     /var
54G     /var/lib/rancher
3.9G    /var/lib/kubelet
454M    /var/log
235M    /var/log/pods
194M    /var/log/journal
166M    /var/lib/apt
85M     /var/cache
79M     /var/cache/apt
19M     /var/lib/dpkg
4.3M    /var/cache/debconf
1.5M    /var/cache/man
1.3M    /var/backups
612K    /var/lib/cni
496K    /var/lib/systemd
368K    /var/log/containers
240K    /var/lib/cloud
92K     /var/log/apt
88K     /var/lib/ucf
```

## List
### journal

Check journal size
```bash
sudo journalctl --disk-usage
```

```bash
sudo journalctl --vacuum-time=7d
```
```
Vacuuming done, freed 3.7G of archived journals from /var/log/journal/c7360c702ef549138d59f24209d027ee.
Vacuuming done, freed 0B of archived journals from /var/log/journal.
```
```bash
sudo journalctl --vacuum-size=500M
```

### Package Manager Apt
```bash
apt clean
apt autoremove
```

### tmp directory
```bash
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
```

### Containerd Image

```bash
# Remove all unused images (9gb)
sudo k3s crictl rmi --prune
```
### Containerd Pods

Usually minimal gain

* Check size of pods directory
```bash
df -h /var/lib/rancher
du -sh /var/lib/rancher/k3s/agent/containerd
```
```
6.5G    /var/lib/rancher/k3s/agent/containerd
```
* Removes pod sandboxes that are in a stopped state (not running).
```bash

# list: crictl pods 
sudo k3s crictl rmp -a
```



Most likely, k3s has been running for months without restart and has a memory leak.