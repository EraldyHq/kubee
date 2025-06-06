// Kube-state metrics customization
// that delete Rbac

local defaults = {
  memory_optimization: error 'memory_optimization is not specified',
};

function(params)

  local values = defaults + params;

  // The kube-prometheus lib
  local kpStateMetrics = (import '../kube-prometheus/components/kube-state-metrics.libsonnet')(params);

  // The base default mixin
  local kubeStateMetrics = (import 'github.com/kubernetes/kube-state-metrics/jsonnet/kube-state-metrics/kube-state-metrics.libsonnet') {
    name:: 'kube-state-metrics',  // name taken from https://github.com/prometheus-operator/kube-prometheus/blob/main/jsonnet/kube-prometheus/components/kube-state-metrics.libsonnet#L7
    namespace:: params.namespace,
    version:: params.version,
    image:: params.image,
  };


  // Our custom values
  local kxStateMetrics = kpStateMetrics
                         // Overwrite all Rbac Configuration
                         // ie get back original manifest (ie service, deployment, ....)
                         + kubeStateMetrics
                         // Update the service Monitor to go to the normal port
                         + {
                           serviceMonitor+: {
                             spec+: {
                               endpoints: [
                                 endpoint {
                                   // Kube-state-metrics endpoint
                                   // 8080: http-metrics by default
                                   // 8081: https-main for kube prometheus thanks to args: ['--host=127.0.0.1', '--port=8081'],
                                   // Telemetry endpoint: https://github.com/kubernetes/kube-state-metrics#kube-state-metrics-self-metrics
                                   // Run on port:
                                   // 8081: telemetry by default
                                   // 8082: https-self for kube-prometheus (thanks to the args: ['--telemetry-host=127.0.0.1', '--telemetry-port=8082'])
                                   port: if super.port == 'https-main' then 'telemetry' else 'http-metrics',
                                   scheme: 'http',
                                   // In dashboard, they use namespace, not exported_namespace as label
                                   // honorLabels will not create the exported field
                                   // label_values(kube_namespace_status_phase{job="kube-state-metrics", cluster="$cluster"}, namespace)
                                   // example metrics: kube_namespace_status_phase
                                   // example dashboard: kubernetes-compute-resources-namespace-pods
                                   honorLabels: true,
                                   // Not overwridden but we can see where the data comes from
                                   interval: params.scrapeInterval
                                 }
                                 for endpoint in kpStateMetrics.serviceMonitor.spec.endpoints
                               ],
                               // The service monitor has the extra label: app.kubernetes.io/part-of: kube-prometheus
                               selector: {
                                 matchLabels: {
                                   'app.kubernetes.io/component': 'exporter',
                                   'app.kubernetes.io/name': 'kube-state-metrics',
                                 },
                               },
                             },
                           },
                         };

  // Put back the security and resources
  kxStateMetrics {
    deployment+: {
      spec+: {
        template+: {
          spec+: {
            containers: [
              // there is only 1 container
              kxStateMetrics.deployment.spec.template.spec.containers[0] {
                securityContext+: {
                  runAsGroup: 65534,
                },
                resources: params.resources,
                args: if values.memory_optimization then [
                    '--resources=certificatesigningrequests,cronjobs,daemonsets,deployments,endpoints,horizontalpodautoscalers,ingresses,jobs,leases,limitranges,mutatingwebhookconfigurations,namespaces,networkpolicies,nodes,persistentvolumeclaims,persistentvolumes,poddisruptionbudgets,pods,replicasets,replicationcontrollers,resourcequotas,services,statefulsets,storageclasses,validatingwebhookconfigurations,volumeattachments'
                ] else []
              },
            ],
          },
        },
      },
    },
  }
