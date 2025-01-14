{{/*
Library of templates createe with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}


{{/*
Helper to print the name for consistency
*/}}
{{- define "kube-x-prometheus-grafana-cloud-secret-name" }}
{{- printf "%s-%s"
    (include "kube-x-name-prefix" .)
    "grafana-cloud"
}}
{{- end }}

{{/*
Helper to print the name for consistency
*/}}
{{- define "kube-x-prometheus-new-relic-secret-name" }}
{{- printf "%s-%s"
    (include "kube-x-name-prefix" .)
    "new-relic"
}}
{{- end }}
