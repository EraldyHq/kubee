% kube-x-cert(1) Version Latest | Print kubernetes certificates in plain text


## Overview

Return the kubeconfig cert in plain text

## SYNOPSIS

     
     Usage of kube-x-cert
     Usage:
     
     Return kubernetes certs in plain text
     
     
         kube-x-cert command
     
     where: command may be:
          * `config-client` : Print the client certificate chain found in the kubeconfig file
          * `config-cluster` : Print the cluster certificate authority in the kubeconfig file
          * `secret` : Print the client certificate in a secret
     
     For more info, see kube-x-cert(1)
     

## Example

```bash
export KUBECONFIG=~/.kube/config
kube-x-cert config-client
```
