# ArgoCd


## About
This directory represents the deployment of ArgoCd.
The apps are in another directory.

This role:
* install and configure argocd via [kustomize](kustomization.yml)
* add the [git repo](templates/argocd-secret-repo.yml)
* add the [github webhook](templates/argocd-secret.yml)

It depends on Vault and External Secrets.

## Test/Check values before installation

To check the [repo creation](templates/argocd-secret-repo.yml)
```bash
kube-x-helx -c kube-x-ssh template argocd | grep 'name: argocd-secret-repo' -A 2 -B 11
```

## How to

### Develop

```bash
kube-x-kubectl apply -k .
```
* with kubectl
```bash
# once
kubectl create namespace argocd
# then
cd argocd
kubectl config set-context --current --namespace=argocd
kubectl apply -k .
```

### Namespace is mandatory

Every manifest should have a namespace.

Otherwise, you get:
```
error: accumulating resources: accumulation err='merging resources from 'helx.yml': 
may not add resource with an already registered id: ConfigMap.v1.[noGrp]/argocd-cmd-params-cm.[noNs]': 
must build at directory: '/home/admin/code/kube-x/resources/charts/argocd/helx.yml': file is not directory
```


### Debug Notifications

* Apply the patch
```bash
kubectl patch cm argocd-notifications-cm -n argocd --type merge --patch-file argo/patches/argocd-notifications-config-map-patch.yml
```
* Test
```bash
kubectl config set-context --current --namespace=argocd
argocd admin notifications template get
```

## Features
### Version

The version is in the [URL path of the kustomization file](kustomization.yml)

### With GitHub WebHook

With [GitHub WebHook](https://argo-cd.readthedocs.io/en/stable/operator-manual/webhook/)


### End Users Notifications

With [Notification](https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/)
To allow end-users to configure notifications

### Change Admin user password

Argo CD does not have its own user management system and has only one built-in user admin.
The initial password is available from a secret named `argocd-initial-admin-secret`.
https://argo-cd.readthedocs.io/en/stable/faq/#i-forgot-the-admin-password-how-do-i-reset-it

Get it via argocd:
```bash
argocd admin initial-password -n argocd
# You should delete the argocd-initial-admin-secret from the Argo CD namespace once you changed the password.
# The secret serves no other purpose than to store the initially generated password in clear and can safely be deleted at any time. It will be re-created on demand by Argo CD if a new admin password must be re-generated.
```

### Create User

To do:
https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/


https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/


#### Manage ArgoCD with ArgoCd

https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#manage-argo-cd-using-argo-cd

https://github.com/argoproj/argoproj-deployments/tree/master/argocd





## Notes on Argo cd project and policies

A project is used to apply policy on deployment
The `default` project created at installation and allows all
https://argo-cd.readthedocs.io/en/stable/user-guide/projects/

## Support

### CPU and memory spike on Sync
App syncing causes big memory spike (and probably CPU spike as well) in application controller.

https://github.com/argoproj/argo-cd/discussions/6964#discussioncomment-1164100
https://github.com/argoproj/argo-cd/discussions/10262

* `--kubectl-parallelism-limit` may be used to limit the number of concurrent resource application processes
* For reposerver there is `--parallelismlimit` to limit the number of concurrent manifest tool invocations
* We are using the `argocd.argoproj.io/manifest-generate-paths` annotation aggressively to avoid that, so that it doesn't generate every single manifest on every commit.

All perf conf are explained [here](https://argo-cd.readthedocs.io/en/stable/operator-manual/high_availability/)
