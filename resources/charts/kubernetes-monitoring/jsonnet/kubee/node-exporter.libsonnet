// node-exporter metrics customization
// that delete Rbac container

local defaults = {
  node_exporter_scrape_interval: error "node_exporter_scrape_interval is not specified"
};


function(params)

  local values = defaults + params;

  local newScheme = 'http';

  // The kube-prometheus lib
  local kpNodeExporter = (import '../kube-prometheus/components/node-exporter.libsonnet')(params);
   kpNodeExporter + {

    // The original daemonset
    // https://github.com/prometheus-operator/kube-prometheus/blob/main/manifests/nodeExporter-daemonset.yaml
    daemonset+: {
      spec+: {
        template+: {
          spec+: {
            containers: [
              container {
                ports: [{
                  containerPort: 9100,
                  hostPort: 9100,
                  name: newScheme,
                }],
              }
              for container in kpNodeExporter.daemonset.spec.template.spec.containers
              if container.name == 'node-exporter'
            ],
          },
        },
      },
    },
    serviceMonitor+: {
      spec+: {
        endpoints: [
          endpoint {
            port: newScheme,
            scheme: newScheme,
            // Not overwridden but we can see where the data comes from
            interval: values.node_exporter_scrape_interval,
          }
          for endpoint in kpNodeExporter.serviceMonitor.spec.endpoints
        ],
      },
    },
  }
