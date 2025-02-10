{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}

{{/*
    Prefix used to see who has created an object,
    We may also use a label by the way
    (Variables are scoped to a template, that's why we use a function)
*/}}
{{- define "kubee-prefix" }}
{{- printf "kubee" }}
{{- end }}
{{/*
Return a name prefix created from the release
Usage in a sub-chart
include "kubee-name-prefix" (dict "Release" .Release "Values" .Values.kubee )
*/}}
{{- define "kubee-name-prefix" }}
{{- printf "%s-%s" .Release.Name (include "kubee-prefix" .)  | replace "_" "-" | trunc 63 -}}
{{- end }}

