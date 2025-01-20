// Adapted from
// https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/refs/tags/v0.14.0/jsonnet/kube-prometheus/components/prometheus.libsonnet
// to go from a role to a clusterRole (ie allow all namespace)
# Prometheus Doc:
# https://prometheus-operator.dev/docs/platform/platform-guide/#deploying-prometheus
# For rbac service account, see:
#   https://prometheus-operator.dev/docs/platform/rbac/
#   https://prometheus-operator.dev/docs/platform/rbac/#prometheus-rbac

function(params)
    local prometheus = (import '../vendor/github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator/prometheus.libsonnet')(params);
    (import '../kube-prometheus/components/prometheus.libsonnet')(params){
        local p = self,
        # delete, roleBindingSpecificNamespaces
        roleBindingSpecificNamespaces:: null,
        roleSpecificNamespaces:: null,
        roleConfig:: null,
        roleBindingConfig:: null,
        # Rbac ClusterRole comes from https://prometheus-operator.dev/docs/platform/rbac/#prometheus-rbac
        clusterRole: {
            apiVersion: 'rbac.authorization.k8s.io/v1',
            kind: 'ClusterRole',
            metadata: p._metadata,
            rules: [
               {
                apiGroups: [''],
                resources: [ 'nodes', 'nodes/metrics', 'services', 'endpoints', 'pods'],
                verbs: ['get', 'list', 'watch']
              },
              {
                apiGroups: [""],
                resources: ['configmaps'],
                verbs: ["get"]
              },
              {
                apiGroups: [ 'discovery.k8s.io' ],
                resources: [ 'endpointslices' ],
                verbs: ["get", "list", "watch"]
               },
              {
                apiGroups: ['networking.k8s.io'],
                resources: [ 'ingresses' ],
                verbs: ["get", "list", "watch"]
              },
              {
                nonResourceURLs: ["/metrics"],
                verbs: ["get"]
              }
            ]
        }

    }

