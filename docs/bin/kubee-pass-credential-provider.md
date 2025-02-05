% kubectx-pass-credential-provider(1) Version Latest | provide client kubernetes credential from pass 
# NAME

An external kube [credential provider](https://github.com/kubernetes/enhancements/blob/master/keps/sig-auth/541-external-credential-providers/README.md#provider-configuration)
based on [pass](https://www.passwordstore.org/)


See [kubectx-env](kubectx-env.md) that explains how the connection information
are retrieved from `pass`

# USAGE EXAMPLE

This is just a dummy example. For more detailed information, see the
[official documentation](https://github.com/kubernetes/enhancements/blob/master/keps/sig-auth/541-external-credential-providers/README.md#provider-configuration)

You can set all driving environments variables defined in [kubectx-env](kubectx-env.md).

Example of `kubeconfig` file using the 
```yaml
apiVersion: v1
kind: Config
users:
- name: my-user
  user:
    exec:
      apiVersion: "client.authentication.k8s.io/v1"
      command: "kubectx-pass-crendential-provider"
      env:
        - name: "KUBEE_USER"
          value: "default"
      installHint: |
        kubee should be installed
      provideClusterInfo: true
      interactiveMode: Never
clusters:
- name: my-cluster
  cluster:
    server: "https://1.2.3.4:8080"
    certificate-authority: "/etc/kubernetes/ca.pem"
    extensions:
    - name: client.authentication.k8s.io/exec  # reserved extension name for per cluster exec config
      extension:
        some-config-per-cluster: config-data  # arbitrary config
contexts:
- name: my-cluster
  context:
    cluster: my-cluster
    user: my-user
current-context: my-cluster
```



