// Adapted from
// https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/refs/tags/v0.14.0/jsonnet/kube-prometheus/components/prometheus-operator.libsonnet
// Without any rbac-proxy and network policies
// Keeping the monitoring mixin only

function(params)
    local prometheusOperator = (import '../vendor/github.com/prometheus-operator/prometheus-operator/jsonnet/prometheus-operator/prometheus-operator.libsonnet')(params);
    (import '../kube-prometheus/components/prometheus-operator.libsonnet')(params){
        # delete, no network policies
        networkPolicy:: null,
    }
    // Overwrite all Rbac Configuration
    // ie get back original manifest (ie service, deployment, ....)
    + prometheusOperator
