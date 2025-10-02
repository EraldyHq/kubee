# K3s Datastore

https://docs.k3s.io/datastore

## Stores
### SQLite

#### Sqlite Size (default)

```bash
du -sh /var/lib/rancher/k3s/server/db/*
```
Working Example:
```
8.0K    /var/lib/rancher/k3s/server/db/etcd
71M     /var/lib/rancher/k3s/server/db/state.db
32K     /var/lib/rancher/k3s/server/db/state.db-shm
4.3M    /var/lib/rancher/k3s/server/db/state.db-wal
```
As long as:
* [compaction](#compaction) is working,
* and you restart k3s periodically
  the database should stay pretty small.

#### SQLITE vacuum

Recent releases of kine/k3s vacuum the sqlite database on startup.
`kine` will also run a `vacuum` at startup,

If a [manual vacuum](#manual-vacuum-and-compaction) reduces your size, k3s may be too old

#### SQLite Analyze with sqlite3_analyzer

```bash
apt-get update
apt-get install sqlite3
apt-get install sqlite3-tools
sqlite3_analyzer /var/lib/rancher/k3s/server/db/state.db
```

#### SQLite Report analytics on kine

Kine is an etcdshim that translates etcd API to:

* SQLite
* Postgres
* MySQL/MariaDB
* NATS

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
71997     /registry/leases/kube-system/apiserver-fohhc347juam3arofccezbofla
71962     /registry/leases/kube-node-lease/kube-server-01.eraldy.com
49956     /registry/leases/kube-system/cert-manager-controller
49921     /registry/leases/kube-system/cert-manager-cainjector-leader-election
5229      /registry/cronjobs/mail/mail-checker-cron
4338      /registry/argoproj.io/applications/argocd/com-datacadamia
...
```


### Etcd  (not default)

Size
```bash
du -sh /var/lib/rancher/k3s/server/db/etcd/
# 8.0K    /var/lib/rancher/k3s/server/db/etcd/
```


## Compaction

Compact is the process of deleting old rows from the database.
The query that handles this is executed periodically by kine. See [](#manual-vacuum-and-compaction)

Check your k3s journald logs for message that look like these, once every 5 minutes:
```bash
journalctl -e -u k3s --since "15 minutes ago" | grep -i compact
```
```bash
Oct 01 08:16:36 kube-server-01.eraldy.com k3s[2237448]: time="2025-10-01T08:16:36Z" level=info msg="COMPACT deleted 1000 rows from 1000 revisions in 906.760433ms - compacted to 43882333/45820240"
Oct 01 08:16:36 kube-server-01.eraldy.com k3s[2237448]: time="2025-10-01T08:16:36Z" level=info msg="COMPACT compactRev=43882333 targetCompactRev=43883333 currentRev=45820241"
```

## Support
### Manual Vacuum and Compaction


```bash
# check actual size
du -sh /var/lib/rancher/k3s/server/db/*
# ls -l /var/lib/rancher/k3s/server/db/
# drwx------ 2 root root        4096 Jun 24  2024 etcd
#-rw-r--r-- 1 root root 12666449920 Oct  1 08:38 state.db
#-rw-r--r-- 1 root root    17989632 Oct  1 08:42 state.db-shm
#-rw-r--r-- 1 root root  9257153872 Oct  1 08:41 state.db-wal

# Stop k3s
systemctl stop k3s

# Backup current database if enough disk space
cp /var/lib/rancher/k3s/server/db/state.db /root/state.db.backup

# Compact using sqlite
sqlite3 /var/lib/rancher/k3s/server/db/state.db 'VACUUM;'

# Check new size
du -sh /var/lib/rancher/k3s/server/db/*
# 8.0K    /var/lib/rancher/k3s/server/db/etcd
# 5.1G    /var/lib/rancher/k3s/server/db/state.db
# 64K     /var/lib/rancher/k3s/server/db/state.db-shm
# 32M     /var/lib/rancher/k3s/server/db/state.db-wal
```

* Compaction (https://github.com/k3s-io/kine/issues/213#issuecomment-1717143914)
```bash
sqlite3 /var/lib/rancher/k3s/server/db/state.db << EOF
.header on
.mode column

delete from kine where id in (select id from (select id, name from kine where id not in (select max(id) as id from kine group by name)));

EOF
```


```bash
# Restart k3s
systemctl start k3s
```

## Discussion

https://github.com/k3s-io/k3s/discussions/13011
