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
