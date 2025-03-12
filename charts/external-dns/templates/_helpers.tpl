{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}


{{define "external-dns-cloudflare-secret-name" }}
{{- include "kubee-name" (merge . (dict "component" "cloudflare")) }}
{{end }}


{{define "external-dns-provider-secret-name" }}
{{- include "kubee-name" (merge . (dict "component" .Values.provider)) }}
{{end }}
