{{/*
Library of templates createe with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}


{{/*
Helper to print the basic auth name for consitency
(used for middelware, ...)
*/}}
{{- define "whoami-name" }}
{{- include "kubee-name-prefix" . }}
{{- end }}