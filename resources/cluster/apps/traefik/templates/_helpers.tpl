{{/*
Library of templates createe with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}

{{/*
Encode the admin and a list of users for the basic auth secret
{{ include "basic-auth-list-base64-encode" . }}
*/}}
{{- define "basic-auth-list-base64-encode" }}
{{- $result := list }}
{{/* Add the admin user */}}
{{- $result = append $result (htpasswd .Values.kube_x.cluster.adminUser.username .Values.kube_x.cluster.adminUser.password | b64enc) }}
{{- range .Values.kube_x.traefik.middleware.basicAuth.users }}
{{- $result = append $result (b64enc .) }}
{{- end }}
{{- join "\n" $result | indent 4}}
{{- end }}
