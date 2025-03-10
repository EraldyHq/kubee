# Secret

Chart by default creates k8s secret.

They may offer a `kind` property where values may be:
* `Secret`: A Kubernetes Secret manifest is created, the values are passed in the values.yaml with environment variables substitution
* `ExternalSecret`: A ExternalSecret Manifest is created that retrieves the value in a store (External Secret chart should be installed). Used for GitOps pulling such as in ArgoCd where the git repository is pulled and applied.