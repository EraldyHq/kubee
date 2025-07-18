## kubeconfig

`kubeconfig` is the file that permits to connect to a Kubernetes cluster.

## How To
### How to see the kubeconfig file

```bash
kubee kubectl config view
```

### How to test a connection

```bash
kubee kubectl cluster-info
```

### How to encrypt

We allow encryption with [pass](kubeconfig-pass.md)

### Check expiration

```bash
kubee cert config-client
```

Example of expired cert
```
0: Certificate
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 6180918950649418648 (0x55c70909a6f05398)
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: CN=k3s-client-ca@1719221384
        Validity
            Not Before: Jun 24 09:29:44 2024 GMT
            Not After : Jun 24 09:29:44 2025 GMT
```

### How to take a new k3s config if expired

* Grab the file `/etc/rancher/k3s/k3s.yaml` and copy it to `$HOME/.kube`
* Modify the `server` properties with your server ip
* Test
```bash
KUBECONFIG=~/.kube/k3s.yaml ./kubee kubectl cluster-info
```
More info: https://docs.k3s.io/cluster-access


Optionally:
  * you can rename it to the default: `$HOME/.kube/config`
  * you can update the client cert if you use [pass to store it](kubeconfig-pass.md)
```bash
# set your names
KUBEE_PASS_HOME=kubee
KUBEE_CLUSTER_NAME=beau # cluster name
KUBEE_USER_NAME=default # user name

# Save the new client
KUBECONFIG=~/.kube/k3s.yaml kubectl config view --minify --raw --output 'jsonpath={$.users[0].user.client-certificate-data}' | pass insert -m "$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-certificate-data"
KUBECONFIG=~/.kube/k3s.yaml kubectl config view --minify --raw --output 'jsonpath={$.users[0].user.client-key-data}' | pass insert -m "$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-key-data"

# Test
./kubee kubectl cluster-info
```

