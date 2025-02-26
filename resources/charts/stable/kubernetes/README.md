# Kubernetes Kubee Chart


## About

This Kubee chart will install `Kubernetes` on your hosts.

## Features

### K3s Ansible

It will install the [k3s Kubernetes distribution](https://docs.k3s.io/)
with the [official k3s-ansible playbooks](https://github.com/k3s-io/k3s-ansible)

### Automatic OIDC Configuration

If [dex](../dex/README.md) is enabled, it is configured as [OIDC issuer](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens)

ie in the [template](#template), the following arguments are added:
```yaml
k3s_extra_server_args:
  - --kube-apiserver-arg="oidc-issuer-url=https://dex-hostname.tld"
  - --kube-apiserver-arg="oidc-client-id=kubernetes"
  - --kube-apiserver-arg="oidc-username-claim=email"
  - --kube-apiserver-arg="oidc-groups-claim=groups"
```

You can then log in with [kubelogin](https://github.com/int128/kubelogin)


## Command

### Template

Verify the configuration. The template will output the ansible inventory file
```bash
kubee --cluster clusterName helmet template kubernetes
```

### Play 

The `play` command deploys Kubernetes on the cluster hosts (Repeatable install and configuration)
```bash
kubee --cluster clusterName helmet play kubernetes
```
Play will execute the [site playbook](https://github.com/k3s-io/k3s-ansible/blob/master/playbooks/site.yml)


### Upgrade

Upgrade the version in [values](values.yaml) and run:
```bash
kubee --cluster clusterName helmet upgrade kubernetes
```
Upgrade will execute the [upgrade playbook](https://github.com/k3s-io/k3s-ansible/blob/master/playbooks/upgrade.yml)`


### Uninstall

!!! Uninstall will delete Kubernetes on all Nodes. !!!

```bash
kubee --cluster clusterName helmet uninstall kubernetes
```

Uninstall will execute the [reset playbook](https://github.com/k3s-io/k3s-ansible/blob/master/playbooks/reset.yml)

