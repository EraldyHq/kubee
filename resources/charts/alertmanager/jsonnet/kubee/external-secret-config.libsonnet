local defaultValues = {
  alert_manager_name: error 'Alert manager Name should be provided',
  external_secrets_store_name: error 'External Secret Store Name should be provided',
  alert_manager_config: error 'Alert Manager Config should be given',
};

local templateVariables = {
  smtp_user_variable: 'SMTP_USER',
  smtp_user_password: 'SMTP_PWD',
  ops_genie_api_key: 'OPS_GENIE_API_KEY',
};

/*
  Alert manager config via an External Secret for GitOps

  Doc over alert manager config
  https://github.com/prometheus-operator/prometheus-operator/blob/main/example/user-guides/alerting/alertmanager-example-service.yaml
  https://prometheus.io/docs/alerting/latest/configuration/#file-layout-and-global-settings
  Example: https://prometheus.io/docs/alerting/latest/configuration/#example
  https://github.com/prometheus/alertmanager/blob/main/doc/examples/simple.yml

*/
function(params) {
  local values = defaultValues + params,

  // A conf for secret in global configuration
  // Doc: https://prometheus-operator.dev/docs/developer/alerting/#using-a-kubernetes-secret
  apiVersion: 'external-secrets.io/v1beta1',
  kind: 'ExternalSecret',
  metadata: {
    // A unique name in the namespace
    name: 'alertmanager-' + values.alert_manager_name,
    labels: {
      'app.kubernetes.io/name': 'alertmanager',
    },
  },
  spec: {
    // The store from where
    secretStoreRef: {
      name: values.external_secrets_store_name,
      kind: 'ClusterSecretStore',
    },
    // The target define the secret created
    // and may be pre-processed via template
    target: {
      // Secret name in Kubernetes
      // 'alertmanager-'+values.alert_manager_name is mandatory
      // so that the promtetheus operator can find it
      name: 'alertmanager-' + values.alert_manager_name,
      template: {
        //  The name of the key holding the configuration data in the Secret has to be alertmanager.yaml
        data: {
          // https://prometheus.io/docs/alerøting/latest/configuration/#file-layout-and-global-settings
          // Example: https://prometheus.io/docs/alerting/latest/configuration/#example
          // https://github.com/prometheus/alertmanager/blob/main/doc/examples/simple.yml
          // A route is mandatory
          'alertmanager.yaml': std.manifestYamlDoc(values.alert_manager_config {
            global+: {
              smtp_auth_username: '{{ .' + templateVariables.smtp_user_variable + ' }}',
              smtp_auth_password: '{{ .' + templateVariables.smtp_user_password + ' }}',
              opsgenie_api_key: '{{ .' + templateVariables.ops_genie_api_key + ' }}',
            },
          }),
        },
        metadata: {
          annotations: {
            description: 'The Global Conf for alert manager',
          },
        },
      },
    },
    // Mapping to local secret from remote secret
    data: [
      {
        secretKey: templateVariables.smtp_user_variable,  // Prop Name in the secret
        remoteRef: {
          key: 'email',  // Name of the remote secret
          property: 'smtp-user',  // Prop Name in the remote secret
        },
      },
      {
        secretKey: templateVariables.smtp_user_password,  // Prop Name in the secret
        remoteRef: {
          key: 'email',  // Name of the remote secret
          property: 'smtp-password',  // Prop Name in the remote secret
        },
      },
      {
        secretKey: templateVariables.ops_genie_api_key,  // Prop Name in the secret
        remoteRef: {
          key: 'opsgenie',  // Name of the remote secret
          property: 'api-key',  // Prop Name in the remote secret
        },
      },
    ],
  },
}
