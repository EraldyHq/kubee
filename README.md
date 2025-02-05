# Kubee - Kubernetes, the Easy Way 

A One-Clik, Single VPS, Self-Hosted Kubernetes Platform


`E` stands for:
* Easy
* Express
* Extra
* Extensible


## Installation

* Mac / Linux / Windows WSL with HomeBrew
```bash
brew install --HEAD gerardnico/tap/kubee
```

## How to

### How to provision a cluster

See [](resources/clusters/kubee-ssh/README.md)


## Contribute 

See [Contribute/Dev](contrib/contribute.md)

## Kubectl Plugins

To make these utilities [Kubectl plugin](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/), 
you can rename them from `kubee-` to `kubectl-`

They should then show up in:
```bash
kubectl plugin list
```


You can discover other plugins at [Krew](https://krew.sigs.k8s.io/plugins/)
