# Kube eXpress - A One-Clik, Single VPS, Self-Hosted Kubernetes Platform




## Steps

### Download requirements

Install all requirements
```bash
ansible-galaxy install -r resources/cluster/requirements.yml
```

### Create Inventory


```bash
export KUBE_X_CLUSTER_API_SERVER_01_IP=78.46.190.50
export KUBE_X_CLUSTER_API_SERVER_01_NAME=kube-vp-server-01
export KUBE_X_CLUSTER_SERVER_USER=root
export KUBE_X_CLUSTER_APEX_DOMAIN=example.com
export KUBE_X_CLUSTER_NAME=kube-vp
export KUBE_X_CLUSTER_K3S_VERSION=v1.31.2+k3s1
export KUBE_X_CLUSTER_TOKEN=jbHWvQv9261KblczY7BX+OLcnZGrMSe+0UiFS3h7Ozc= # To generate a token: `openssl rand -base64 32 | tr -d '\n'`

envsubst < resources/inventory.yml >| conf/inventory.yml
```


### Kubernetes Installation

```bash
ansible-playbook -i conf/inventory.yml $ANSIBLE_HOME/collections/ansible_collections/k3s/orchestration/playbooks/site.yml
ansible-playbook -i conf/inventory.yml k3s.orchestration.site.yml
ansible-galaxy collection list
```

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