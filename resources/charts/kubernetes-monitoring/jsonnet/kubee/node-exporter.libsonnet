// node-exporter metrics customization
// that delete Rbac container


function(params)


  // The kube-prometheus lib
  local kpNodeExporter = (import '../kube-prometheus/components/node-exporter.libsonnet')(params);


  // Our custom values
  kpNodeExporter
  // Update the service Monitor to go to the normal port
  {
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
            interval: params.scrapeInterval,
          }
          for endpoint in kpNodeExporter.serviceMonitor.spec.endpoints
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
  }
