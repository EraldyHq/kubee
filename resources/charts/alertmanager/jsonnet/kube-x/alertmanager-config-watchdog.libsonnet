/*
      The opsgenie alert manager config
      https://github.com/prometheus/alertmanager/blob/main/config/testdata/conf.opsgenie-both-file-and-apikey.yml
      https://prometheus.io/docs/alerting/latest/configuration/#opsgenie_config
      One receiver by priority as stated here:
      https://support.atlassian.com/opsgenie/docs/integrate-opsgenie-with-prometheus/
*/
local defaultValues = {
  watchdog_email_to: error 'watchdog_email_to should be provided',
  watchdog_email_repeat_interval: error 'watchdog_email_repeat_interval should be provided',
  watchdog_webhook_url: error 'watchdog_webhook_url should be provided',
  watchdog_webhook_repeat_interval: error 'watchdog_webhook_repeat_interval should be provided',
};

local receiverNameWebHook = 'WatchdogWebHook';
local receiverNameEmail = 'WatchdogEmail';
local nullReceiverName = 'null';

// Opsgenie
function(params) {
  local values = defaultValues + params,
  // CRD
  AlertmanagerConfig: {
    apiVersion: 'monitoring.coreos.com/v1alpha1',
    kind: 'AlertmanagerConfig',
    metadata: {
      name: 'watchdog',
      labels: {
        'app.kubernetes.io/name': 'alertmanager',
      },
    },
    spec: {
      /*
        Route
        https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1alpha1.Route
      */
      route: {
        // A top receiver is mandatory
        receiver: nullReceiverName,
        // Only watch dog enter this route
        matchers: [{ name: 'alertname', value: 'Watchdog' }],
        // One route by receiver
        routes: []
                + (if values.watchdog_webhook_url == '' then [] else
                     [{
                       receiver: receiverNameWebHook,
                       continue: true,
                       repeatInterval: values.watchdog_webhook_repeat_interval,
                     }])
                + (if values.watchdog_email_to == '' then [] else
                     [{
                       receiver: receiverNameEmail,
                       continue: true,
                       repeatInterval: values.watchdog_email_repeat_interval,
                     }]),
      },
      receivers: [{
                   name: nullReceiverName,
                 }]
                 + (if values.watchdog_webhook_url == '' then [] else [
                      {
                        name: receiverNameWebHook,
                        webhookConfigs: [{
                          url: values.watchdog_webhook_url,
                        }],
                      },
                    ])
                 + (if values.watchdog_email_to == '' then [] else [
                      {
                        name: receiverNameEmail,
                        emailConfigs: [{
                          to: values.watchdog_email_to,
                        }],
                      },
                    ]),
    },
  },
}
