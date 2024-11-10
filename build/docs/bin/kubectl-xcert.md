% kubectl-xcert(1) Version Latest | Print kubernetes certificates in plain text


## Overview

Return the kubeconfig cert in plain text

## SYNOPSIS

     
     Usage of kubectl-xcert
     Usage:
     
     Return kubernetes certs in plain text
     
     
         kubectl-xcert command
     
     where: command may be:
          * `config-client` : Print the client certificate chain found in the kubeconfig file
          * `config-cluster` : Print the cluster certificate authority in the kubeconfig file
          * `secret` : Print the client certificate in a secret
     
     For more info, see kubectl-xcert(1)
     

## Example

```bash
export KUBECONFIG=~/.kube/config
kubectl-xcert config-client
```
