% kubee-pvc-move(1) Version Latest | Shows the pods ip
# Overview

Move a local-path pv

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Not finished, you should apply the command one by one manually for now
Prerequisites:
* You should have the ssh private key on the source host
* Rsync on both nodes

!!!!!!!!!!!!!!!!!!!!!!!!!!!

Original Idea: [how-to-move-pv-from-one-kubernetes-node-to-another](https://stackoverflow.com/questions/71708673/how-to-move-pv-from-one-kubernetes-node-to-another)

There is no direct way of moving a rancher.io/local-path pv
Since the data is only available on the node the pv has been provisioned on.

To move the pv, the data has to be moved first. Then the pv has to be patched to point to the new host.

See [pv-migrate](https://github.com/utkuozdemir/pv-migrate)



## Help

This script need to be performed manually line by line
