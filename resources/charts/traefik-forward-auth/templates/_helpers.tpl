{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}


{{- define "traefik-forward-auth-port" }}
{{- printf "4181" }}
{{- end }}

