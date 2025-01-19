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
  - the templates are rendered
  - `kustomize` is applied
  - the output is added to the Jsonnet templates if present

# JSONNET

The project file system layout is:
* the project directory is the subdirectory `jsonnet`
* it contains optionally the jsonnet bundler manifest `jsonnetfile.json`
* the main file is called `main.jsonnet`
* the files found at the project root directory with the extension `jsonnet` are executed in multimode, each key of the Json object is a manifest path (ie with the `--multi` flag of Jsonnet)
  * Single mode execution is supported but not recommended. It happens when the Jsonnet script contains the term `single` (ie the expected output should be a single json manifest)   

  
The Jsonnet script:
* can get the helm `values` via the `values` jsonnet external variable.
* should not output manifest path in multimode that contains directory. ie only a name, no slash

Minimal Working Example:
```jsonnet
local values =  {
    kube_x: {
        prometheus: {
            // The error is triggered as access time, not build time
            namespace: error 'must provide namespace',
        }
    }
} + (std.extVar('values'));

// A multimode json where each key represent the name of the generated manifest and is unique
{
   // no slash, no subdirectory in the file name
   // ie not `setup/my-manifest` for instance
   "my-manifest": {
       apiVersion: 'xxx',
       kind: 'xxx',
       metatdata: {
         namespace: values.kube_x.prometheus.namespace
       }
    }
}
```

Note: the name `values` is a standard because this is similar to helm (used for instance by [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus/blob/8e16c980bf74e26709484677181e6f94808a45a3/jsonnet/kube-prometheus/main.libsonnet#L17))

> [!TIP]
> You can reuse the jsonnet project as a Jsonnet bundler dependency
> ```bash
> jb install https://github.com/workspace/repo/path/to/chart/jsonnet@main
> ```


# KUSTOMIZATION

* Your chart can reference Helm templates directly. They will be rendered before passing them to `kustomize`
* The kustomization file can include the `${KUBE_X_NAMESPACE}` environment variable. Why? To support [this case](https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/#installing-argo-cd-in-a-custom-namespace)


Example:
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: ${KUBE_X_NAMESPACE}
patches:
  - path: templates/patches/secret-patch.yml
  - patch: |-
      - op: replace
        path: /subjects/0/namespace
        value: ${KUBE_X_NAMESPACE}
    target:
      kind: ClusterRoleBinding
resources:
  - https://raw.githubusercontent.com/orga/project/vx.x.x/manifests/install.yaml
  - templates/resources/ingress.yml
```

> [!NOTE]
> Kustomize won't let you have multiple resources with the same GVK, name, and namespace
> because it expects each resource to be unique.
> If a resource template report an error, setting it as a patch template, may resolve the problem.

# EXAMPLE

Check the [kube-x-argocd](../../resources/charts/argocd) chart for a kustomization example.
