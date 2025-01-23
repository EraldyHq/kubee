local validation = import './kube_x/validation.libsonnet';

local kxExtValues = std.extVar('values');
// Values are flatten, so that we can:
// * use the + operator and the error pattern in called library
// * we can easily rename
local kxValues = {

  kubernetes_monitoring_namespace: validation.notNullOrEmpty(kxExtValues, 'kube_x.kubernetes_monitoring.namespace'),
  grafana_name: validation.notNullOrEmpty(kxExtValues, 'kube_x.grafana.name'),
  grafana_folder: 'kubernetes-monitoring',

};

local stripJson = function(name) std.substr(name, 0, std.length(name) - std.length('.json'));

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

local dashboards = (import 'github.com/kubernetes-monitoring/kubernetes-mixin/mixin.libsonnet') {
  _config+:: {
    // Kubernetes Scheduler and Controller manager metrics comes from the api server endpoint
    // in k3s
    kubeSchedulerSelector: 'job="apiserver"',
    kubeControllerManagerSelector: self.kubeSchedulerSelector,
  },
}.grafanaDashboards;

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
                    // The api server endpoint gives you metrics from controller manager and scheduler as well.
                    // You have all the metrics but rules and dashboard don't expect them to be tagged with job=apiserver.
                    // Ref: https://github.com/k3s-io/k3s/issues/425#issuecomment-813017614
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
              if !(std.objectHas(endpoint, 'path') && endpoint.path == '/metrics/slis')
            ],
          },
        }
      else kubernetesControlPlane[name]
    )
  for name in std.objectFields(kubernetesControlPlane)
  // k3s is only one binary and does not have KubeScheduler and KubeControllerManager
  if !std.member(['serviceMonitorKubeScheduler', 'serviceMonitorKubeControllerManager'], name)
} +
{
  'kubernetes-monitoring-grafana-folder': {
    apiVersion: 'grafana.integreatly.org/v1beta1',
    kind: 'GrafanaFolder',
    metadata: {
      name: kxValues.grafana_folder,
    },
    spec: {
      instanceSelector: {
        matchLabels: {
          dashboards: 'grafana',
        },
      },
      // If title is not defined, the value will be taken from metadata.name
      title: 'kubernetes-monitoring',
    },
  },
} +
{
  ['kubernetes-monitoring-grafana-dashboard-' + stripJson(name)]: {
    apiVersion: 'grafana.integreatly.org/v1beta1',
    kind: 'GrafanaDashboard',
    metadata: {
      name: 'kubernetes-monitoring-' + stripJson(name),
    },
    spec:
      {
        // Allow import from grafana instance in another namespace
        // https://github.com/grafana/grafana-operator/tree/master/examples/crossnamespace
        // https://grafana.github.io/grafana-operator/docs/examples/crossnamespace/readme/
        allowCrossNamespaceImport: true,
        // https://grafana.github.io/grafana-operator/docs/overview/#resyncperiod
        // 10m by default
        // 0m: never poll for changes in the dashboards
        resyncPeriod: '0m',
        folder: kxValues.grafana_folder,
        // https://grafana.github.io/grafana-operator/docs/overview/#instanceselector
        instanceSelector: {
          matchLabels: {
            dashboards: kxValues.grafana_name,
          },
        },
        // std.manifestJson to output a Json string
        json: std.manifestJson(dashboards[name]),
      },
  }
  for name in std.objectFields(dashboards)
}
