/*
      The pagerduty config
*/
local defaultValues = {
  pagerduty_service_key: error 'Pagerduty Service Key should be provided',
  pagerduty_url: error 'Pagerduty Url should be provided',
};

// Opsgenie
function(params) {
  local values = defaultValues + params,
  // Alert manager Global
  // https://prometheus.io/docs/alerting/latest/configuration/#file-layout-and-global-settings
  global: {
    pagerduty_url:: values.pagerduty_url,
  },
  /**
   https://prometheus.io/docs/alerting/latest/configuration/#pagerduty_config
  */
  receivers: [
    {
      name: 'pagerduty',
      service_key: values.pagerduty_service_key,
    },
  ],

}
