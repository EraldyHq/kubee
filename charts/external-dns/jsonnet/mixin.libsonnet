{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ExternalDns',
        rules: [
          {
            local alert = 'ExternalDnsRegistryError',
            alert: alert,
            expr: |||
              external_dns_registry_errors_total > 0
            |||,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'External DNS has {{ $value }} registry errors',
            },
          },
          {
            local alert = 'ExternalDnsSourceError',
            alert: alert,
            expr: |||
              external_dns_source_errors_total > 0
            |||,
            'for': '20m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'External DNS has {{ $value }} source errors',
            },
          },
          {
            local alert = 'ExternalDnsLastSuccessfulSync',
            alert: alert,
            expr: |||
              avg by (exported_namespace, namespace, name) (time() - external_dns_controller_last_sync_timestamp_seconds )
              > (%s * 60) # 1 minute
            ||| % '5',
            'for': '1h',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'External DNS does not have successfully sync since {{ $value | humanizeDuration }}.',
              description: 'No successful DNS sync since {{ $value | humanizeDuration }}.',
            },
          },
        ],
      },
    ],
  },
}
