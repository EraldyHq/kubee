% kube-x-helm-post-renderer(1) Version Latest | A Helm Post renderer
# NAME

`kube-x-helm-post-renderer` is a  [helm post renderer](https://helm.sh/docs/topics/advanced/#post-rendering)
that adds support for:
* `Jsonnet` 
* and `kustomize`

# SYNOPSIS

${SYNOPSIS}

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

The project:
* file system layout is:
  * the project directory is the subdirectory `jsonnet`
  * it contains optionally jsonnet bundler artifacts such as:
    * the manifest `jsonnetfile.json`
    * the `vendor` directory
  * the main file is called `main.jsonnet`
* can be:
  * opened as an independent project (by `VsCode`, `Idea`)
  * used as a Jsonnet bundler dependency
```bash
jb install https://github.com/workspace/repo/path/to/chart/jsonnet@main
```

Execution: the files found at the project root directory with the extension `jsonnet` are executed:
* by default, in multimode, each key of the Json object is a manifest path (ie Jsonnet is executed with the `--multi` flag)
* in single mode (supported but not recommended) when the Jsonnet script name contains the term `single` (ie the expected output should be a single json manifest)


The Jsonnet script:
* get:
  * the `values` file via the `values` jsonnet external variable.
  * all default values via the `values` file (no value means error)
* if in multimode, should not output manifest path that contains directory (ie no slash in the name)

 

Minimal Multimode `main.jsonnet` Working Example:
```jsonnet
local extValues = std.extVar('values');

// The name `values` is a standard because this is similar to helm 
// (used for instance by [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus/blob/8e16c980bf74e26709484677181e6f94808a45a3/jsonnet/kube-prometheus/main.libsonnet#L17))
local values =  {
    kube_x: {
        prometheus: {
            namespace: kube_x.prometheus.namespace,
        }
    }
};

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


To validate, you can take example in our [validation library](../../resources/charts/alertmanager/jsonnet/kube_x/validation.libsonnet).

Minimal Example:
```jsonnet
local extValues = std.extVar('values');
local validation = import './kube_x/validation.libsonnet';
# This will throw an error if there is no property. It should as the values file should have the default.
local email = validation.getNestedPropertyOrThrow(extValues, 'kube_x.cluster.adminUser.email');
# This will throw an error if there is no property and if this is the empty string.
local namespace = validation.notNullOrEmpty(extValues,'kube_x.alertmanager.namespace');
{
    "my-manifest": {
       apiVersion: 'xxx',
       kind: 'xxx',
       metatdata: {
         namespace: namespace
       },
       spec: {
        email: email
       }
    }
}
```

Ide Plugins, as of 2025-01-20, choose your winner.
* The [Idea Databricks Jsonnet Plugin](https://plugins.jetbrains.com/plugin/10852-jsonnet) is:
  * heavy used by Databricks
  * can navigate the code. `import` 
    * works only for relatif path, 
    * does not support `jpath`
  * does not support formatting the whole document
* The Grafana Json Server in [Vs Code](https://github.com/grafana/vscode-jsonnet) or [Intellij](https://plugins.jetbrains.com/plugin/18752-jsonnet-language-server)
  * navigation works only if the document has no errors 
  * supports `jpath` (ie `import namespace/name` can be navigated)
  * supports formatting the whole document

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
> If a resource template reports an error, setting it as a patch template, may resolve the problem.

# EXAMPLE

Check the [kube-x-argocd](../../resources/charts/argocd) chart for a kustomization example.
