/*
      The opsgenie alert manager config
      https://github.com/prometheus/alertmanager/blob/main/config/testdata/conf.opsgenie-both-file-and-apikey.yml
      https://prometheus.io/docs/alerting/latest/configuration/#opsgenie_config
      One receiver by priority as stated here:
      https://support.atlassian.com/opsgenie/docs/integrate-opsgenie-with-prometheus/
*/
local defaultValues = {
  smtp_host: error 'smtp_host Key should be provided',
  smtp_port: error 'smtp_port Key should be provided',
  smtp_hello: error 'smtp_hello Key should be provided',
  admin_user_email: error 'admin_user_email Key should be provided',

};

// Get the smtpFromEmail
local smtpFromEmail = function(values) (
  if values.smtp_from != '' then
    values.smtp_from else if values.admin_user_email != '' then
    values.admin_user_email else
    error 'No email could be determined for the `for` email header. Set at least: kube_x.auth.admin_user.email'
);


// Helper function that returns null for empty strings
local nonEmpty(str) = if std.length(str) > 0 then str;

local receiverName = 'email';

// Opsgenie
function(params) {
  local values = defaultValues + params,
  // Alert manager Global
  // Email
  // https://prometheus.io/docs/alerting/latest/configuration/#file-layout-and-global-settings
  AlertmanagerGlobal: {

    smtp_smarthost: values.smtp_host + ':' + values.smtp_port,
    smtp_require_tls: true,
    smtp_from: smtpFromEmail(values),
    [if values.smtp_hello != null then 'smtp_hello']: values.smtp_hello,
    smtp_auth_username: nonEmpty(values.smtp_username),
    smtp_auth_password: nonEmpty(values.smtp_password),

  },
  // CRD
  AlertmanagerConfig: {
    apiVersion: 'monitoring.coreos.com/v1alpha1',
    kind: 'AlertmanagerConfig',
    metadata: {
      name: 'email',
      labels: {
        'app.kubernetes.io/name': 'alertmanager',
      },
    },
    spec: {
      // The root route on which each incoming alert enters.
      // https://prometheus.io/docs/alerting/latest/configuration/#route
      route: {
        // All alerts that do not match any child routes will remain at the root node and be dispatched to 'default-receiver'
        // The default receiver
        // Changed by Prometheus to: `Namespace/AlertManagerConfigName/ReceiverName`
        receiver: receiverName,
        // The labels by which incoming alerts are grouped together
        // example: group_by: ['alertname', 'cluster', 'service', 'job']
        groupBy: ['alertname'],
        // When a new group of alerts is created by an incoming alert, wait at least 'group_wait' to send the initial notification.
        // This way ensures that you get multiple alerts for the same group that start
        // firing shortly after another are batched together on the first notification.
        groupWait: '30s',
        // When the first notification was sent, wait 'group_interval'
        // to send a batch of new alerts that started firing for that group (default = 5m)
        groupInterval: '5m',
        // If an alert has successfully been sent, wait 'repeat_interval' to resend them (default = 4h)
        repeatInterval: '1h',
        // No none severity (ie watchdog)
        matchers: [{
          name: 'severity',
          value: 'none',
          matchType: '!=',
        }],
      },
      receivers: [
        {
          // Email
          // https://prometheus.io/docs/alerting/latest/configuration/#email_config
          name: receiverName,
          emailConfigs: [{
            to: values.admin_user_email,
          }],
        },
      ],
    },
  },
}
