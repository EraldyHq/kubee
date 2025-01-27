local defaultValues = {
  admin_user_email: error 'admin user email should be provided',
};

/*
  # A alert manager config (by namespace)
    # https://prometheus-operator.dev/docs/developer/alerting/#using-alertmanagerconfig-resources
    # https://github.com/prometheus/alertmanager/blob/main/config/testdata/conf.opsgenie-both-file-and-apikey.yml
    # https://prometheus.io/docs/alerting/latest/configuration/#opsgenie_config
*/
function(params) {
  local values = defaultValues + params,
  assert values.admin_user_email != '' : error 'admin user email should not be empty',
  apiVersion: 'monitoring.coreos.com/v1alpha1',
  kind: 'AlertmanagerConfig',
  metadata: {
    name: 'default',
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
      receiver: 'default',
      // The labels by which incoming alerts are grouped together
      // example: group_by: ['alertname', 'cluster', 'service', 'job']
      groupBy: ['job'],
      // When a new group of alerts is created by an incoming alert, wait at least 'group_wait' to send the initial notification.
      // This way ensures that you get multiple alerts for the same group that start
      // firing shortly after another are batched together on the first notification.
      groupWait: '30s',
      // When the first notification was sent, wait 'group_interval'
      // to send a batch of new alerts that started firing for that group (default = 5m)
      groupInterval: '5m',
      // If an alert has successfully been sent, wait 'repeat_interval' to resend them (default = 4h)
      repeatInterval: '1h',
    },
    receivers: [
      {
        // Email
        // https://prometheus.io/docs/alerting/latest/configuration/#email_config
        name: 'default',
        emailConfigs: [{
          to: values.admin_user_email,
        }],
      },
    ],
  },
}
