# K3-backup


## Steps

### Backup
* Always back up your token.
* If you're using 
  * etcd snapshots, take snapshots and back them up somewhere. 
  * sqlite, stop the server and back up the sqlite files. 
  * an external database, back that up.
* If you have persistent volumes, use whatever tool your storage vendor recommends.

https://github.com/k3s-io/k3s/discussions/5886


### Restoration

To roll back a K3s cluster when using a SQLite database, replace the `.db` file with the copy of the `.db` file you made while backing up your database.

Restoring the `state.db` file works (as long as the `shm` and `wal` files are deleted before restore).
See [k3s-datastore](k3s-datastore-sqlite.md)

## Related Rollback

You can roll back the K3s Kubernetes version after an upgrade, using a combination of
  * K3s binary downgrade 
  * and datastore restoration.

[rollback](https://docs.k3s.io/upgrades/roll-back)
