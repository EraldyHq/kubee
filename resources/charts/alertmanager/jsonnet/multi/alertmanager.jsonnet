// To execute
// rm -rf jsonnet/multi/manifests && mkdir -p jsonnet/multi/manifests/setup && jsonnet -J vendor --multi jsonnet/multi/manifests "jsonnet/multi/kube-prometheus.jsonnet" --ext-code "values={ kube_x: std.parseYaml(importstr \"../../kube-x/values.yaml\") }" | xargs -I{} sh -c 'cat {} | gojsontoyaml > "{}.yaml" && rm {}' -- {}


local values =  {
    kube_x: {
        cluster: {
            adminUser:{
                email: ''
            },
            email: {
                smtp: {
                    host: '',
                    port: error 'kube_x.cluster.email.smtp.port is empty',
                    from: '',
                    username: '',
                    password: '',
                    hello: ''
                }
            }
        },
        alertmanager: {
            enabled: error 'must provide alert manager enabled',
            namespace: error 'must provide alert manager namespace',
            hostname: '',
            opsgenie:{
                apiKey: ''
            }
        },
    }
} + (std.extVar('values'));


// Function that create an alertmanager patch
/*
  # Defines an alert manager pod
  # For each Alertmanager resource, the Operator deploys a StatefulSet in the same namespace.
  # https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.Alertmanager
  # Example: https://github.com/prometheus-operator/prometheus-operator/blob/main/example/user-guides/alerting/
  # equivalent to alertmanager.yml ?
*/
local alertManagerPatch = ( if values.kube_x.alertmanager.hostname != '' then { externalUrl: 'https://'+ values.kube_x.alertmanager.hostname } else {} )
    + {
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
            type: 'None'
        },
    }
;


// Get the alertManagerVersion from jsonnetfile.json
local jsonnetfile = (import '../../jsonnetfile.json');
local alertManagerVersion = std.filter(
    function(x) x.source.git.remote == "https://github.com/prometheus/alertmanager.git",
    jsonnetfile.dependencies)[0].version;

// Get the smtpFromEmail
local smtpFromEmail  = ( if values.kube_x.cluster.email.smtp.from != '' then
    values.kube_x.cluster.email.smtp.from else if values.kube_x.cluster.adminUser.email != '' then
    values.kube_x.cluster.adminUser.email else
    error "No email could be determined for the `for` email header. Set at least: kube_x.cluster.adminUser.email"
);

// Helper function that returns null for empty strings
local nonEmpty(str) = if std.length(str) > 0 then str;

// Email
local smtpObject = ( if values.kube_x.cluster.email.smtp.host != '' then
    {
        smtp_smarthost: values.kube_x.cluster.email.smtp.host+':'+values.kube_x.cluster.email.smtp.port,
        smtp_require_tls: true,
        smtp_from: smtpFromEmail,
        smtp_hello: nonEmpty(values.kube_x.cluster.email.smtp.hello),
        smtp_username: nonEmpty(values.kube_x.cluster.email.smtp.username),
        smtp_password: nonEmpty(values.kube_x.cluster.email.smtp.password)
    });

// Opsgenie
local opsGenieObject = ( if values.kube_x.alertmanager.opsgenie.apiKey != '' then {
        opsgenie_api_key: values.kube_x.alertmanager.opsgenie.apiKey,
        opsgenie_api_url: 'https://api.opsgenie.com/'
    });

// Kube Prometheus Alert Manager Object
local alertmanager = (import '../lib/alertmanager.libsonnet')(
      {
        name: 'alertmanager', # main by default
        version: alertManagerVersion,
        namespace: values.kube_x.alertmanager.namespace,
        image: 'quay.io/prometheus/alertmanager:'+alertManagerVersion,
        // Number of replicas of each shard to deploy
        // Default is 1 for an alert manager crd but kube-prometheus set it to 2
        replicas: 1,
        resources: {
            limits: {}, // cpu: '10m', memory: '50Mi'
            requests: {},
        },
        config+:: {
            // The Global Conf for alert manager
            global+: {
              // Clients are expected to continuously re-send alerts as long as they are still active (usually on the order of 30 seconds to 3 minutes)
              // An alert is considered as resolved if it has not been resend after the resolve_timeout configuration.
              resolve_timeout: '5m',
            }
            + smtpObject
            + opsGenieObject,
        }
      }
);

{
    ['alertmanager-' + name]:
        alertmanager[name]
        + (if alertmanager[name].kind == 'Alertmanager' then { spec+: alertManagerPatch } )
    for name in std.objectFields(alertmanager)
} + ( if values.kube_x.alertmanager.opsgenie.apiKey != '' then
    /*
          The opsgenie alert manager config
          https://github.com/prometheus/alertmanager/blob/main/config/testdata/conf.opsgenie-both-file-and-apikey.yml
          https://prometheus.io/docs/alerting/latest/configuration/#opsgenie_config
          One receiver by priority as stated here:
          https://support.atlassian.com/opsgenie/docs/integrate-opsgenie-with-prometheus/
    */
    {
        'alert-manager-opsenie-config': {
            apiVersion: 'monitoring.coreos.com/v1alpha1',
            kind: 'AlertmanagerConfig',
            metadata: {
              name: 'opsgenie',
              labels: {
                'app.kubernetes.io/name': 'alertmanager'
                }
            },
            spec: {
            /*
              Route
              https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1alpha1.Route
            */
              route: {
                receiver: "opsgenie",

                routes: [
                  {
                       receiver: "opsgenie-critical",
                        # !!! Match properties does not work !!!
                        # Matcher: https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1alpha1.Matcher
                        matchers: [{
                             name: "severity",
                            value: "critical",
                            matchType: "="
                        }],
                  },
                  {
                    receiver: "opsgenie-warning",
                    matchers: [{
                        name: "severity",
                        value: "warning",
                        matchType: "="
                        }],
                  }
                ]
              },
              receivers: [
                {
                  name: "opsgenie-critical",
                  opsgenieConfigs: [{ priority: 'P1' }]
                },
                {
                    name: "opsgenie-warning",
                  opsgenieConfigs: [{ priority: 'P2' }]
                },
                {
                  name: "opsgenie",
                  opsgenieConfigs: [{ priority: 'P3' }]
                }
              ]
            }
        }
    })
