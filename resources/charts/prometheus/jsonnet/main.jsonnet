// https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/customizing.md


local validation = import './kube_x/validation.libsonnet';

local kxExtValues = std.extVar('values');
// Values are flatten, so that we can:
// * use the + operator and the error pattern in called library
// * we can easily rename
local kxValues = {

  # Cluster
  cluster_name: validation.notNullOrEmpty(kxExtValues, 'kube_x.cluster.name'),

  # Secret
  secret_type: validation.notNullOrEmpty(kxExtValues, 'kube_x.cluster.secret'),
  external_secret_store_name: validation.notNullOrEmpty(kxExtValues, 'external_secrets.store.name'),

  // Cert Manager
  cert_manager_enabled: validation.getNestedPropertyOrThrow(kxExtValues, 'kube_x.cert_manager.enabled'),
  cert_manager_issuer_name: validation.getNestedPropertyOrThrow(kxExtValues, 'cert_manager.defaultIssuerName'),

  // Local
  prometheus_namespace: validation.notNullOrEmpty(kxExtValues, 'namespace'),
  prometheus_hostname: validation.getNestedPropertyOrThrow(kxExtValues, 'hostname'),
  prometheus_memory: validation.getNestedPropertyOrThrow(kxExtValues, 'resources.memory'),
  prometheus_retention: validation.getNestedPropertyOrThrow(kxExtValues, 'retention'),
  prometheus_version: '3.1.0',
  prometheus_operator_memory: validation.getNestedPropertyOrThrow(kxExtValues, 'operator.resources.memory'),
  prometheus_operator_version: '0.79.2',
  // No Rbac Proxy Sidecar or Network Policies
  // Why? Takes 20Mb memory by exporter
  noRbacProxy: true,
  // Grafana Remote write
  grafana_cloud_enabled: validation.notNullOrEmpty(kxExtValues, 'grafana_cloud.enabled'),
  grafana_cloud_prometheus_username: validation.notNullOrEmpty(kxExtValues, 'grafana_cloud.username'),
  grafana_cloud_prometheus_password: validation.notNullOrEmpty(kxExtValues, 'grafana_cloud.password'),
  grafana_cloud_relabel_keep_regexp: validation.getNestedPropertyOrThrow(kxExtValues, 'grafana_cloud.relabel_keep_regex'),
  // New Relic
  new_relic_enabled: validation.notNullOrEmpty(kxExtValues, 'new_relic.enabled'),
  new_relic_bearer: validation.notNullOrEmpty(kxExtValues, 'new_relic.bearer'),
  new_relic_relabel_keep_regexp: validation.getNestedPropertyOrThrow(kxExtValues, 'new_relic.relabel_keep_regex'),


};

local kp =
  (import 'kube-prometheus/main.libsonnet') +
  {
    values+:: {
      common+: {
        namespace: kxValues.prometheus_namespace,
        versions+: {
          prometheus: kxValues.prometheus_version,
          prometheusOperator: kxValues.prometheus_operator_version,
        },
      },
      alertmanager: {
        name: 'main',  // mandatory, the default kxValues used by kube-prometheus
      },
      prometheusOperator+: {
        resources:: {
          requests: { memory: kxValues.prometheus_operator_memory },
          limits: { memory: kxValues.prometheus_operator_memory },
        },
      },
      // for prometheus, we overwrite the config in kube_x/prometheus.libsonnet
    },
  };

// Prometheus Operator without Rbac Configuration (ie with original manifest)
local prometheusOperator = (
  if kxValues.noRbacProxy then
    (import './kube_x/prometheus-operator-rbac-free.libsonnet')(kp.values.prometheusOperator)
  else
    kp.prometheusOperator
);

// Prometheus Custom
local customPrometheus = (import './kube_x/prometheus.libsonnet')(kp.values.prometheus, kxValues);

{
  ['prometheus-operator-' + name]: prometheusOperator[name]
  // CRD are in the prometheus-crd charts
  for name in std.filter((function(name) prometheusOperator[name].kind != 'CustomResourceDefinition'), std.objectFields(prometheusOperator))
} +
//{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
//{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) } +
{ ['prometheus-prometheus-' + name]: customPrometheus[name] for name in std.objectFields(customPrometheus) }
