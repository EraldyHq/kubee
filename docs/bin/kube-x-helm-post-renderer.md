% kube-x-helm-post-renderer(1) Version Latest | A Helm Post renderer
# NAME

`kube-x-helm-post-renderer` is a  [helm post renderer](https://helm.sh/docs/topics/advanced/#post-rendering)
that adds support for:
* `Jsonnet` 
* and `kustomize`

# SYNOPSIS

$SYNOPSIS

# HOW IT WORKS

- if a `jsonnet` directory exists at the root of the chart directory
  - if a `jsonnetfile.json` is present, the `jsonnet bundler` is executed to fetch dependencies
  - the `jsonnet` files present in the `jsonnet` directory are executed 
  - the output are added to the Helm templates
- if a `kustomization.yml` is present at the root of the chart directory
  - the environment variables present in `kustomization.yml` are substituted 
  - `kustomize` is applied on the whole set of templates (Helm + Jsonnet templates)

# JSONNET

* The files with the extension `jsonnet` stored in the `jsonnet` directory are executed.
* The output is added as new manifest.

# KUSTOMIZATION

* Your chart should have a `kustomization.yml` file at the root with a resources called `kube-x-helm-x-templates.yml`
* The kustomization file can include the `${KUBE_X_NAMESPACE}` environment variable.

Kustomize won't let you have multiple resources with the same GVK, name, and namespace because it expects each resource to be unique.

Example:
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: ${KUBE_X_NAMESPACE}
patches:
  - patch: |-
      - op: replace
        path: /subjects/0/namespace
        value: ${KUBE_X_NAMESPACE}
    target:
      kind: ClusterRoleBinding
resources:
  - https://raw.githubusercontent.com/orga/project/vx.x.x/manifests/install.yaml
  - kube-x-helm-x-templates.yml
```

Why? To support [this case](https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/#installing-argo-cd-in-a-custom-namespace)
