local validation = import './kube_x/validation.libsonnet';

local kxExtValues = std.extVar('values');
// Values are flatten, so that we can:
// * use the + operator and the error pattern in called library
// * we can easily rename
local kxValues = {

  kubernetes_monitoring_namespace: validation.notNullOrEmpty(kxExtValues, 'kube_x.kubernetes_monitoring.namespace'),

};


local kubernetesControlPlane = (import './kube-prometheus/components/k8s-control-plane.libsonnet')(
  {
    namespace: kxValues.kubernetes_monitoring_namespace,
  }
);
local custom = (import './kube-prometheus/components/mixin/custom.libsonnet')(
  {
    namespace: kxValues.kubernetes_monitoring_namespace,
  }
);
{ 'kube-custom-prometheusRule': custom.prometheusRule } +

{
  ['kubernetes-monitoring-' + name]:
    (
      if name == 'prometheusRule'
      then
        local prometheusRule = kubernetesControlPlane[name];
        prometheusRule {
          spec: {
            groups: [
              group
              for group in prometheusRule.spec.groups
              // We filter out the following groups
              if !std.member([
                    'kubernetes-apps',  // metrics are from kube-state-metrics
                    'kubernetes-resources',  // metrics are from kube-state-metrics
                    'kubernetes-system-controller-manager',  // k3s does not have any controller-manager, no need to alert
                    'kubernetes-system-scheduler',  // k3s does not have any scheduler, no need to alert
                    ], group.name)
            ],
          },
        }
      else if name == 'serviceMonitorKubelet' then
        local serviceMonitorKubelet = kubernetesControlPlane[name];
        serviceMonitorKubelet {
          spec+: {
            endpoints: [
              endpoint
              for endpoint in serviceMonitorKubelet.spec.endpoints
              // We filter out the /metrics/slis target
              // https://github.com/k3s-io/k3s/discussions/11637
              if !(std.objectHas(endpoint, "path") && endpoint.path == '/metrics/slis')
            ],
          },
        }
      else kubernetesControlPlane[name]
    )
  for name in std.objectFields(kubernetesControlPlane)
  // k3s is only one binary and does not have KubeScheduler and KubeControllerManager
  if !std.member(['serviceMonitorKubeScheduler', 'serviceMonitorKubeControllerManager'], name)
}
