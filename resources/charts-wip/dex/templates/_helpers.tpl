{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}

{{/*
    The name of the cert
*/}}
{{- define "dex-cert-name" }}
{{- printf "dex-cert" }}
{{- end }}

{{- define "dex-conf-name" }}
{{- printf "dex-conf" }}
{{- end }}

{{- define "dex-service-name" }}
{{- printf "dex-service" }}
{{- end }}