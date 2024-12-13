{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}

{{/*
Return a name prefix
Usage in a sub-chart
include "kube-x-name-prefix" (dict "Release" .Release "Values" .Values.kube_x )
*/}}
{{- define "kube-x-name-prefix" }}
{{- printf "%s-%s" .Release.Name .Values.templates.globalPrefix | replace "_" "-" | trunc 63 -}}
{{- end }}


{{/*
Return the name of the traefik basic auth
*/}}
{{- define "kube-x-traefik-basic-auth-name" }}
{{- printf "%s-middelware-basic-auth" .Values.templates.globalPrefix -}}
{{- end }}

{{/*
Return the name of the traefik transport that can be used as label
*/}}
{{- define "kube-x-traefik-basic-auth-label-name" }}
{{- printf "%s-%s@kubernetescrd"
    .Values.traefik.namespace
    (include "kube-x-traefik-basic-auth-name" .)
-}}
{{- end }}