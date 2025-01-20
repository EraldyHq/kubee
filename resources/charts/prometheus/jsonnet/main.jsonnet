// https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/customizing.md

local extValues = std.extVar('values');
local validation = import './kube_x/validation.libsonnet';


local values =  {
    kube_x: {
        prometheus: {
            // The error is triggered as access time, not build time
            namespace: validation.notNullOrEmpty(extValues, 'kube_x.prometheus.namespace'),
            // https://prometheus.io/docs/prometheus/3.1/getting_started/
            // --storage.tsdb.retention.time=24h
            // scrape frequency
            resources: {
                memory: validation.getNestedPropertyOrThrow(extValues, 'kube_x.prometheus.resources.memory')
            },
            prometheus_operator: {
                // was running on 31.5
                memory: validation.getNestedPropertyOrThrow(extValues, 'kube_x.prometheus.operator.resources.memory')
            },
            // No Rbac Proxy Sidecar or Network Policies
            // Why? Takes 20Mb memory by exporter
            noRbacProxy: true
        },
    }
};

local kp =
  (import 'kube-prometheus/main.libsonnet') +
  {
    values+:: {
      common+: {
        namespace: values.kube_x.prometheus.namespace,
        versions+: {
            prometheus: "3.1.0",
            prometheusOperator: "0.79.2",
        }
      },
      alertmanager: {
        name: 'main' # mandatory, the default values used by kube-prometheus
      },
      prometheusOperator+:{
         resources:: {
            requests: { memory: values.kube_x.prometheus.prometheus_operator.memory },
            limits: { memory: values.kube_x.prometheus.prometheus_operator.memory },
         },
      },
      prometheus+:{
        resources:: {
            requests: { memory: values.kube_x.prometheus.resources.memory },
            limits: { memory: values.kube_x.prometheus.resources.memory },
         },
      }
    },
  };

// Prometheus Operator without Rbac Configuration (ie with original manifest)
local prometheusOperator = (if values.kube_x.prometheus.noRbacProxy then
    (import './kube_x/prometheus-operator-rbac-free.libsonnet')(kp.values.prometheusOperator)
    else
    kp.prometheusOperator
);

{
  ['prometheus-operator-' + name ]: prometheusOperator[name]
  // CRD are in the prometheus-crd charts
  for name in std.filter((function(name) prometheusOperator[name].kind != 'CustomResourceDefinition'), std.objectFields(prometheusOperator))
} +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) }
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) }