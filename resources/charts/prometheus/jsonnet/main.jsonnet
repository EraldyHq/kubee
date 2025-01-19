// https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/customizing.md

local values =  {
    kube_x: {
        prometheus: {
            // The error is triggered as access time, not build time
            namespace: error 'must provide namespace',
            // https://prometheus.io/docs/prometheus/3.1/getting_started/
            // --storage.tsdb.retention.time=24h
            // scrape frequency
            memory: "200Mi",
            prometheus_operator: {
                // was running on 31.5
                memory: "50Mi"
            }
        }
    }
} + (std.extVar('values'));

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
        name: 'alertmanager'
      },
      prometheusOperator+:{
         resources:: {
            requests: { memory: values.kube_x.prometheus.prometheus_operator.memory },
            limits: { memory: values.kube_x.prometheus.prometheus_operator.memory },
         },
      },
      prometheus+:{
        resources:: {
            requests: { memory: values.kube_x.prometheus.memory },
            limits: { memory: values.kube_x.prometheus.memory },
         },
      }
    },
  };

{
  ['prometheus-operator-' + name ]: kp.prometheusOperator[name]
  // CRD are in the prometheus-crd charts
  for name in std.filter((function(name) kp.prometheusOperator[name].kind != 'CustomResourceDefinition'), std.objectFields(kp.prometheusOperator))
} +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) }
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) }