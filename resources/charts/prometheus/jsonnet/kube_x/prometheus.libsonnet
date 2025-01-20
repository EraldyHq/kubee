// Adapted from
// https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/refs/tags/v0.14.0/jsonnet/kube-prometheus/components/prometheus.libsonnet
// to go from a role to a clusterRole (ie allow all namespace)
// Prometheus Doc:
// https://prometheus-operator.dev/docs/platform/platform-guide/#deploying-prometheus
// For rbac service account, see:
//   https://prometheus-operator.dev/docs/platform/rbac/
//   https://prometheus-operator.dev/docs/platform/rbac/#prometheus-rbac


function(params, values)
  local prometheus = (import '../vendor/github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator/prometheus.libsonnet')(params);
  (import '../kube-prometheus/components/prometheus.libsonnet')(params) {
    local p = self,
    // delete, roleBindingSpecificNamespaces
    roleBindingSpecificNamespaces:: null,
    roleSpecificNamespaces:: null,
    roleConfig:: null,
    roleBindingConfig:: null,
    // Rbac ClusterRole comes from https://prometheus-operator.dev/docs/platform/rbac/#prometheus-rbac
    clusterRole: {
      apiVersion: 'rbac.authorization.k8s.io/v1',
      kind: 'ClusterRole',
      metadata: p._metadata,
      rules: [
        {
          apiGroups: [''],
          resources: ['nodes', 'nodes/metrics', 'services', 'endpoints', 'pods'],
          verbs: ['get', 'list', 'watch'],
        },
        {
          apiGroups: [''],
          resources: ['configmaps'],
          verbs: ['get'],
        },
        {
          apiGroups: ['discovery.k8s.io'],
          resources: ['endpointslices'],
          verbs: ['get', 'list', 'watch'],
        },
        {
          apiGroups: ['networking.k8s.io'],
          resources: ['ingresses'],
          verbs: ['get', 'list', 'watch'],
        },
        {
          nonResourceURLs: ['/metrics'],
          verbs: ['get'],
        },
      ],
    },
    [if values.kube_x.prometheus.hostname != '' then 'ingress']: {
      apiVersion: 'networking.k8s.io/v1',
      kind: 'Ingress',
      metadata: p._metadata {
        annotations+: {
          'traefik.ingress.kubernetes.io/router.entrypoints': 'websecure',
          'traefik.ingress.kubernetes.io/router.tls': 'true',
          /* Auth*/
          'traefik.ingress.kubernetes.io/router.middlewares': 'kube-system-traefik-dashboard-auth@kubernetescrd',
          // Issuer
          [if values.kube_x.cert_manager.enabled then 'cert-manager.io/cluster-issuer']: values.kube_x.cert_manager.defaultIssuerName,
        },
      },
      spec: {
        rules: [
          {
            host: values.kube_x.prometheus.hostname,
            http: {
              paths: [{
                backend: {
                  service: {
                    name: p._metadata.name,
                    port: {
                      number: 9090,
                    },
                  },
                },
                path: '/',
                pathType: 'Prefix',
              }],
            },
          },
        ],
        tls: [{
          hosts: [values.kube_x.prometheus.hostname],
          secretName: 'prometheus-cert',
        }],
      },
    },
  }
