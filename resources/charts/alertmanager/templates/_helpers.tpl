{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}


{{/*
Name Helper
Set in spec.configSecret of Alertmanager crd
alertmanager-{ALERTMANAGER_NAME}1 is the default name that we use
*/}}
    {{- define "alert-manager-name" }}
{{- printf "alertmanager-%s" .Values.name }}
{{- end }}

