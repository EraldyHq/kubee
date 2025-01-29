local defaultValues = {
  cert_manager_enabled: error 'Cert Manager enabled should be provided',
  cert_manager_issuer_name: error 'Cert Manager Issuer Name should be provided',
  alert_manager_hostname: error 'Alert manager host Name should be provided',
  alert_manager_name: error 'Alert manager Name should be provided',
};

/*
  # https://github.com/prometheus-operator/prometheus-operator/blob/main/example/user-guides/alerting/alertmanager-example-service.yaml
  # https://prometheus-operator.dev/docs/platform/platform-guide/#exposing-the-alertmanager-service
  # We don't use a node port, we use an ingress
*/
function(params) {
  local values = defaultValues + params,
  apiVersion: 'networking.k8s.io/v1',
  kind: 'Ingress',
  metadata: {
    name: 'alertmanager',
    labels: {
      'app.kubernetes.io/name': 'alertmanager',
    },
    annotations: {
      'traefik.ingress.kubernetes.io/router.entrypoints': 'websecure',
      'traefik.ingress.kubernetes.io/router.tls': 'true',
      /* Auth */
      'traefik.ingress.kubernetes.io/router.middlewares': 'kube-system-traefik-dashboard-auth@kubernetescrd',
      [if values.cert_manager_enabled then 'cert-manager.io/cluster-issuer']: values.cert_manager_issuer_name,
    },
  },
  spec: {
    rules: [
      {
        host: values.alert_manager_hostname,
        http: {
          paths: [{
            backend: {
              service: {
                name: 'alertmanager-' + values.alert_manager_name,
                port: { number: 9093 },
              },
            },
            path: '/',
            pathType: 'Prefix',
          }],
        },
      },
    ],
    tls: [{
      hosts: [values.alert_manager_hostname],
      secretName: 'alertmanager-cert',
    }],
  },
}
