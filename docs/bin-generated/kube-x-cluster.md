# Kube eXpress - A One-Clik, Single VPS, Self-Hosted Kubernetes Platform






### Copy KUBECONFIG and connection test

```bash
# env
export KUBECONFIG=~/.kube/config.new
# permission
chmod 600 "$KUBECONFIG"
kubectl config use-context k3s-ansible
# if on localhost
kubectl config set-cluster k3s-ansible --server=https://127.0.0.1:6443
kubectl config set-cluster k3s-ansible --server="https://$CLUSTER_API_SERVER_IP:6443"
kubectl cluster-info # we should connect to the API
kubectl get nodes # we should see a node
helm list -n kube-system
# change server (IP for now because the FQDN should be set before installing kube)
# otherwise `tls: failed to verify certificate: x509: certificate is valid for kube-test-server-01, kubernetes, kubernetes.default, kubernetes.default.svc, kubernetes.default.svc.cluster.local, localhost, not kube-test-server-01.xxx`
kubectl config rename-context k3s-ansible $KUBE_X_CLUSTER_NAME
# test
kubectl cluster-info dump
```

### Test

Other tests: https://technotim.live/posts/k3s-etcd-ansible/#testing-your-cluster

## Dependencies

* `yq` to update kubeconfig
* `openssl` to generate a random token
* [ans-x (ansible)](https://github.com/ansible-x)
* `kubectl` to talk to the server and install kustomize apps
* `helm` to install helm package
* `docker` to create and run image