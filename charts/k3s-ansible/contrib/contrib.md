# Contrib / Dev


## Why Kubernetes provisioning is a Chart

Because, we use the power of Helm values to apply logical configuration.

Example:
  * apply the oidc flag if the dex chart is enabled.

Furthermore, we can create and support any provisioning tool such as:
* k3d
* k3sup
* Terraform
* and the like



## With the helmet command

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