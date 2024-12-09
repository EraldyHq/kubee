# Kube eXpress - A One-Clik, Single VPS, Self-Hosted Kubernetes Platform






### Copy KUBECONFIG and connection test

```bash
ssh-agent add /path/to/your/private/key
scp root@kube-test-server-01.gerardnico.com:/etc/rancher/k3s/k3s.yaml ~/.kube/config
# or 
scp -i /path/to/your/private/key root@kube-test-server-01.gerardnico.com:/etc/rancher/k3s/k3s.yaml ~/.kube/config
# env
export KUBECONFIG=~/.kube/config
# permission
chmod 600 "$KUBECONFIG"
# change server (IP for now because the FQDN should be set before installing kube)
# otherwise `tls: failed to verify certificate: x509: certificate is valid for kube-test-server-01, kubernetes, kubernetes.default, kubernetes.default.svc, kubernetes.default.svc.cluster.local, localhost, not kube-test-server-01.xxx`
yq e ".clusters[0].cluster.server = \"https://$CLUSTER_API_SERVER_IP:6443\"" -i "$KUBECONFIG"
kubectl config rename-context default $CLUSTER_NAME
# test
kubectl cluster-info dump
```

## Dependencies

* `yq` to update kubeconfig
* `openssl` to generate a random token
* [ans-x (ansible)](https://github.com/ansible-x)
* `kubectl` to talk to the server and install kustomize apps
* `helm` to install helm package
* `docker` to create and run image