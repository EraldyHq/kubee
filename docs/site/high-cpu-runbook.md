# High CPU


The load of 3.01 per core is quite high - typically you want it below 1.0 per core. Since it's sustained over 15 minutes, this suggests an ongoing issue rather than a temporary spike.

## Kine

Kine is an etcdshim that translates etcd API to:

SQLite
Postgres
MySQL/MariaDB
NATS

## CPU analysis

k3s is the parent process for all containers, you need to drill down to see which pod/container is actually consuming resources

```bash
# Get the node name from your alert
kubectl top node <node-name>
```
```
NAME                        CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
kube-server-01.eraldy.com   3050m        76%    5992Mi          77%
```


```bash
# Check resource usage of pods on that node
kubectl top pods --all-namespaces --sort-by=cpu --field-selector spec.nodeName=kube-server-01.eraldy.com
# Script failed use the global debug flag ie (kubee --debug kubectl) to get more information

kubectl debug node/<node-name> -it --image=ubuntu
# Then inside the container:
chroot /host
top -c -o %CPU
ps aux --sort=-%cpu | head -20


htop
```






## k3s check journal
```bash
journalctl -u k3s -f --since "15 minutes ago"
# or ?
journalctl -e -u k3s
```

Since k3s runs everything on the host (not in VMs), the problematic process will show up directly in top.
A load of 3.01 per core suggests either CPU-bound processes or significant I/O blocking.

## Top


This tells a clear story - you have severe memory pressure causing the high load:
The Problem

* Memory exhausted: Only 132 MB free out of 7.7 GB total
* kswapd0 using CPU: This kernel process (PID 57) swaps memory to disk when RAM is full
* High I/O wait (wa): 9.7% - the system is waiting on disk I/O (memory swapping)
* k3s-server using 232% CPU and 2.1 GB RAM - this is abnormally high


The high load average (5.40, 10.09, 11.80 - getting worse over time) is caused by:
* Memory thrashing: System is constantly swapping because you have no swap space and RAM is 95%+ full
* Processes are blocking waiting for memory/I/O
* kswapd0 is desperately trying to free memory


## Similar

https://github.com/k3s-io/k3s/discussions/10306

## Load average

yields load average typically around 8-9 vs. other customers' systems which usually sit between about 1.0 and 3.0. 
k3s as highest CPU user per top

## Analyze

```bash
apt-get update
apt-get install sqlite3
apt-get install sqlite3-tools
sqlite3_analyzer /var/lib/rancher/k3s/server/db/state.db
```

```bash
sqlite3 /var/lib/rancher/k3s/server/db/state.db << EOF
.header on
.mode column
.dbinfo

SELECT 
  COUNT(*) AS rows, 
  (SELECT prev_revision FROM kine WHERE name = "compact_rev_key" LIMIT 1) AS compact_rev,
  MAX(id) AS current_rev
FROM kine;

SELECT COUNT(*), name FROM kine GROUP BY name ORDER BY COUNT(*) DESC LIMIT 50;

EOF
```
output
```
rows    compact_rev  current_rev
------  -----------  -----------
919771  44903333     45821272
COUNT(*)  name
--------  ------------------------------------------------------------
278873    /registry/leases/cert-manager/trust-manager-leader-election

77684     /registry/masterleases/188.245.43.250

71997     /registry/leases/kube-system/apiserver-fohhc347juam3arofccez
          bofla

71962     /registry/leases/kube-node-lease/kube-server-01.eraldy.com

49956     /registry/leases/kube-system/cert-manager-controller

49921     /registry/leases/kube-system/cert-manager-cainjector-leader-
          election

5229      /registry/cronjobs/mail/mail-checker-cron

4338      /registry/argoproj.io/applications/argocd/com-datacadamia

```

## Compact vacuum

Compact is the process of deleting old rows from the database. The query that handles this is executed periodically by kine.

kine will also run a vacuum at startup,
so as long as compaction is working,
and you restart k3s periodically, the database should stay pretty small.

Recent releases of kine/k3s vacuum the sqlite database on startup.
If a manual vacuum reduces your size, I'd be curious what version of k3s you're using as this should already be occurring automatically.
https://github.com/k3s-io/k3s/discussions/10306#discussioncomment-13370656
```bash
# Stop k3s
systemctl stop k3s

# Backup current database
cp /var/lib/rancher/k3s/server/db/state.db /root/state.db.backup
mv /root/state.db.backup /tmp/state.db.backup

ls -l /var/lib/rancher/k3s/server/db/
# drwx------ 2 root root        4096 Jun 24  2024 etcd
#-rw-r--r-- 1 root root 12666449920 Oct  1 08:38 state.db
#-rw-r--r-- 1 root root    17989632 Oct  1 08:42 state.db-shm
#-rw-r--r-- 1 root root  9257153872 Oct  1 08:41 state.db-wal

# Compact using sqlite
sqlite3 /var/lib/rancher/k3s/server/db/state.db 'VACUUM;'

ls -l /var/lib/rancher/k3s/server/db/
# total 5242936
# drwx------ 2 root root       4096 Jun 24  2024 etcd
# -rw-r--r-- 1 root root 5368762368 Oct  1 09:52 state.db

# Check new size
du -sh /var/lib/rancher/k3s/server/db/state.db

# Restart k3s
systemctl start k3s
```

Stop k3
https://github.com/k3s-io/kine/issues/213#issuecomment-1717143914
```sql
delete from kine where id in (select id from (select id, name from kine where id not in (select max(id) as id from kine group by name)));
```


## Free Analysis disk usage

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

## Free space on disk

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

```bash
apt clean
apt autoremove
```

tmp
```bash
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
```



## Free Containerd Space

```bash
# Stop unused containers
sudo k3s crictl rmi --prune

# Remove unused images
sudo k3s crictl rmi $(sudo k3s crictl images -q)

# Clean up containerd
sudo k3s crictl rmp -a
```

## Compaction Log


Check your k3s journald logs for message that look like these, once every 5 minutes:
```bash
journalctl -e -u k3s --since "15 minutes ago" | grep -i compact
```
```bash
Oct 01 08:16:36 kube-server-01.eraldy.com k3s[2237448]: time="2025-10-01T08:16:36Z" level=info msg="COMPACT deleted 1000 rows from 1000 revisions in 906.760433ms - compacted to 43882333/45820240"
Oct 01 08:16:36 kube-server-01.eraldy.com k3s[2237448]: time="2025-10-01T08:16:36Z" level=info msg="COMPACT compactRev=43882333 targetCompactRev=43883333 currentRev=45820241"
```




## Check datastore size

/var/lib/rancher/k3s/server/db/state.db is > 2GB, vs. < 50 MB on other systems.


https://docs.k3s.io/datastore

```bash
du -sh /var/lib/rancher/k3s/server/db/
```
12G     /var/lib/rancher/k3s/server/db/
Normal k3s datastore: 100-500 MB
/usr/bin/sqlite3_analyzer /var/lib/rancher/k3s/server/db/state.db
```bash
ls -l /var/lib/rancher/k3s/server/db/
```
```
total 12369780
drwx------ 2 root root        4096 Jun 24  2024 etcd
-rw-r--r-- 1 root root 12666449920 Oct  1 07:58 state.db
-rw-r--r-- 1 root root      196608 Oct  1 07:58 state.db-shm
-rw-r--r-- 1 root root           0 Oct  1 07:58 state.db-wal
```

```bash
# Stop k3s
systemctl stop k3s

# Backup current database
cp /var/lib/rancher/k3s/server/db/state.db /root/state.db.backup

# Compact using sqlite
sqlite3 /var/lib/rancher/k3s/server/db/state.db 'VACUUM;'

# Check new size
du -sh /var/lib/rancher/k3s/server/db/state.db

# Restart k3s
systemctl start k3s
```



## If using etcd, check its size
```bash
du -sh /var/lib/rancher/k3s/server/db/etcd/
8.0K    /var/lib/rancher/k3s/server/db/etcd/
```

Most likely, k3s has been running for months without restart and has a memory leak.