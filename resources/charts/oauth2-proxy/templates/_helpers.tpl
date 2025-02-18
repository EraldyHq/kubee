{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}

{{- define "oauth2-proxy-service-name" }}
{{- print "oauth2-proxy" }}
{{- end }}

{{- define "oauth2-proxy-service-account-name" }}
{{- include "kubee-name-prefix" . }}
{{- end }}

{{- define "oauth2-proxy-config-secret-name" }}
{{- printf "%s-%s" (include "kubee-name-prefix" .) "config-secret" }}
{{- end }}

{{- define "oauth2-proxy-config-map-name" }}
{{- printf "%s-%s" (include "kubee-name-prefix" .) "config-map" }}
{{- end }}

{{- define "oauth2-proxy-authenticated-emails-name" }}
{{- printf "%s-%s" (include "kubee-name-prefix" .) "authenticated-emails" }}
{{- end }}

{{- define "oauth2-proxy-authenticated-emails-file-name" }}
{{- printf "%s.%s" (include "oauth2-proxy-authenticated-emails-name" .) "csv" }}
{{- end }}

{{/* The name of the local ca cert and its secret for the service */}}
{{- define "oauth2-proxy-cert-local-name" }}
{{- printf "%s-%s" (include "kubee-name-prefix" .) "tls-local"}}
{{- end }}

{{- define "oauth2-proxy-https-port" }}
{{- print "4443" }}
{{- end }}
{{- define "oauth2-proxy-metrics-port" }}
{{- print "44180" }}
{{- end }}