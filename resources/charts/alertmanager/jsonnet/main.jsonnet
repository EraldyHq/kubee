// To execute
// rm -rf jsonnet/multi/manifests && mkdir -p jsonnet/multi/manifests/setup && jsonnet -J vendor --multi jsonnet/multi/manifests "jsonnet/multi/kube-prometheus.jsonnet" --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}

local extValues = std.extVar('values');

// Validation Library
local validation = import './kube-x/validation.libsonnet';

local values = {

  admin_user_email: validation.getNestedPropertyOrThrow(extValues, 'kube_x.auth.admin_user.email'),
  smtp_host: validation.getNestedPropertyOrThrow(extValues, 'kube_x.email.smtp.host'),
  smtp_port: validation.getNestedPropertyOrThrow(extValues, 'kube_x.email.smtp.port'),
  smtp_from: validation.getNestedPropertyOrThrow(extValues, 'kube_x.email.smtp.from'),
  smtp_username: validation.getNestedPropertyOrThrow(extValues, 'kube_x.email.smtp.username'),
  smtp_password: validation.getNestedPropertyOrThrow(extValues, 'kube_x.email.smtp.password'),
  smtp_hello: validation.getNestedPropertyOrThrow(extValues, 'kube_x.email.smtp.hello'),
  alert_manager_name: validation.notNullOrEmpty(extValues, 'name'),
  alert_manager_version: validation.notNullOrEmpty(extValues, 'version'),
  alert_manager_namespace: validation.notNullOrEmpty(extValues, 'namespace'),
  alert_manager_hostname: validation.getNestedPropertyOrThrow(extValues, 'hostname'),
  alert_manager_opsgenie_apikey: validation.getNestedPropertyOrThrow(extValues, 'opsgenie.api_key'),
  alert_manager_memory: validation.getNestedPropertyOrThrow(extValues, 'resources.memory'),
  cert_manager_enabled: validation.getNestedPropertyOrThrow(extValues, 'cert_manager.enabled'),
  cert_manager_issuer_name: validation.getNestedPropertyOrThrow(extValues, 'cert_manager.issuer_name'),
  prometheus_interval: validation.getNestedPropertyOrThrow(extValues, 'prometheus.scrape_interval'),
  secret_kind: validation.getNestedPropertyOrThrow(extValues, 'secret.kind'),
  external_secrets_store_name: validation.getNestedPropertyOrThrow(extValues, 'external_secrets.store.name'),
  grafana_name: validation.getNestedPropertyOrThrow(extValues, 'grafana.name'),

};


// Function that create an alertmanager patch
/*
  # Defines an alert manager pod
  # For each Alertmanager resource, the Operator deploys a StatefulSet in the same namespace.
  # https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.Alertmanager
  # Example: https://github.com/prometheus-operator/prometheus-operator/blob/main/example/user-guides/alerting/
  # equivalent to alertmanager.yml ?
*/
local alertManagerPatch = {
  // External Url
  [if values.alert_manager_hostname != '' then 'externalUrl']: 'https://' + values.alert_manager_hostname,
  // Select all config Objects
  alertmanagerConfigSelector: {},
  // Select all namespace
  alertmanagerConfigNamespaceSelector: {},
  // By default, the alert manager had a matcher on the namespace
  // We disable this match ie
  // For a alertmanagerConfig in the namespace kube-prometheus, it would add to the route
  // matchers:
  //  - namespace="kube-prometheus"
  // See: https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.AlertmanagerConfigMatcherStrategy
  alertmanagerConfigMatcherStrategy: {
    type: 'None',
  },
}
;


// Get the smtpFromEmail
local smtpFromEmail = (
  if values.smtp_from != '' then
    values.smtp_from else if values.admin_user_email != '' then
    values.admin_user_email else
    error 'No email could be determined for the `for` email header. Set at least: kube_x.auth.admin_user.email'
);

// Helper function that returns null for empty strings
local nonEmpty(str) = if std.length(str) > 0 then str;

// Email
// https://prometheus.io/docs/alerting/latest/configuration/#file-layout-and-global-settings
local smtpGolbalConfigObject = (if values.smtp_host == '' then {} else
                                  {
                                    smtp_smarthost: values.smtp_host + ':' + values.smtp_port,
                                    smtp_require_tls: true,
                                    smtp_from: smtpFromEmail,
                                    [if values.smtp_hello != null then 'smtp_hello']: values.smtp_hello,
                                    smtp_auth_username: nonEmpty(values.smtp_username),
                                    smtp_auth_password: nonEmpty(values.smtp_password),
                                  });

// Ops Genie
local opsGenieGlobalConfigObject = (if values.alert_manager_opsgenie_apikey == '' then null else (import 'kube-x/ops-genie.libsonnet')(values));

// Kube Prometheus Alert Manager Object
local alertmanager = (import './kube-prometheus/components/alertmanager.libsonnet')(
  {
    name: values.alert_manager_name,  // main by default, mandatory for installation
    version: values.alert_manager_version,
    namespace: values.alert_manager_namespace,
    image: 'quay.io/prometheus/alertmanager:' + values.alert_manager_version,
    // Number of replicas of each shard to deploy
    // Default is 1 for an alert manager crd but kube-prometheus set it to 2
    replicas: 1,
    resources: {
      limits: { memory: values.alert_manager_memory },
      requests: { cpu: '10m', memory: values.alert_manager_memory },
    },
    config+:: {
      // The Global Conf for alert manager
      global+: {
                 // Clients are expected to continuously re-send alerts as long as they are still active (usually on the order of 30 seconds to 3 minutes)
                 // An alert is considered as resolved if it has not been resend after the resolve_timeout configuration.
                 resolve_timeout: '5m',
               }
               + smtpGolbalConfigObject
               + (if opsGenieGlobalConfigObject == null then {} else opsGenieGlobalConfigObject.Alertmanager),
    },
  }
);


// 30s is the kube-prometheus default
local serviceMonitorPatch = {
  endpoints: [
    { port: 'web', interval: values.prometheus_interval },
    { port: 'reloader-web', interval: values.prometheus_interval },
  ],
};


// Returned Objects
{
  ['alertmanager-' + name]:
    alertmanager[name]
    + (if alertmanager[name].kind == 'Alertmanager' then { spec+: alertManagerPatch } else {})
    + (if alertmanager[name].kind == 'ServiceMonitor' then { spec+: serviceMonitorPatch } else {})
  for name in std.objectFields(alertmanager)
  // filter out network policy otherwise no ingress from Traefik
  // Secret is managed apart as we allow also a ExternalSecrets
  if !std.member(['NetworkPolicy', 'Secret'], alertmanager[name].kind)
} + {
  // Ops Genie Config Object
  [if opsGenieGlobalConfigObject != null then 'alertmanager-config-ops-genie']: opsGenieGlobalConfigObject.AlertmanagerConfig,
  // Ingress
  [if values.alert_manager_hostname != '' then 'alertmanager-ingress']: (import 'kube-x/ingress.libsonnet')(values),
  // AlertManager Config (is in a secret)
  'alertmanager-secret-config': if std.asciiLower(values.secret_kind) == 'externalsecret' then
    (import 'kube-x/external-secret-config.libsonnet')(values {
      alert_manager_config: std.parseYaml(alertmanager.secret.stringData['alertmanager.yaml']),
    })
  else
    alertmanager.secret,
  // Default Config to send an email
  'alertmanager-config-default' : (import 'kube-x/alertmanager-config-default.libsonnet')(values),
} +  (import 'kube-x/mixin-grafana.libsonnet')(values{
          mixin: alertmanager.mixin,
          mixin_name: 'alertmanager',
          grafana_name: values.grafana_name,
          grafana_folder_label: 'Alertmanager',
      })
