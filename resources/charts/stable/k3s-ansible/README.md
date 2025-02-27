# k3s Ansible Cluster Kubee Chart


## About

This Kubee chart is a [cluster chart](../../../../docs/site/cluster-chart.md) that will install [k3s Kubernetes distribution](https://docs.k3s.io/) on your hosts
with the [official k3s-ansible playbooks](https://github.com/k3s-io/k3s-ansible)

## Features


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
kubee --cluster clusterName helmet template k3s-ansible
```

### Play 

The `play` command deploys Kubernetes on the cluster hosts (Repeatable install and configuration)

```bash
kubee --cluster clusterName --cluster-chart k3s-ansible cluster play
```
Play will execute the [site playbook](https://github.com/k3s-io/k3s-ansible/blob/master/playbooks/site.yml)


### Upgrade

Upgrade the version in [values](values.yaml) and run:
```bash
kubee --cluster clusterName --cluster-chart k3s-ansible cluster upgrade
```
Upgrade will execute the [upgrade playbook](https://github.com/k3s-io/k3s-ansible/blob/master/playbooks/upgrade.yml)`


### Uninstall

!!! Uninstall will delete Kubernetes on all Nodes. !!!

```bash
kubee --cluster clusterName --cluster-chart k3s-ansible cluster uninstall
```

Uninstall will execute the [reset playbook](https://github.com/k3s-io/k3s-ansible/blob/master/playbooks/reset.yml)

### Reboot

Reboot the servers hosts then the agents hosts.
```bash
kubee --cluster clusterName --cluster-chart k3s-ansible cluster uninstall
```

Reboot will execute the [reboot playbook](https://github.com/k3s-io/k3s-ansible/blob/master/playbooks/reboot.yml)

## Note

### With the helmet command
You can also run the following command with the helmet command
```bash
# Play
kubee --cluster clusterName helmet play k3s-ansible
# Upgrade
kubee --cluster clusterName helmet upgrade k3s-ansible
# Uninstall
kubee --cluster clusterName helmet uninstall k3s-ansible
# Conf
kubee --cluster clusterName helmet template k3s-ansible
```