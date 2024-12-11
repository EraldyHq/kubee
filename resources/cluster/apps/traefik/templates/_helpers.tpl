
{{/*
Encode a list of user for the basic auth secret
{{ include "basic-auth-list-base64-encode" (list "a" "b" "v") -}}
*/}}
{{- define "basic-auth-list-base64-encode" }}
{{- $result := list }}
{{/* Add the admin user */}}
{{- $result = append $result (htpasswd .Values.kube_x.cluster.adminUser.username .Values.kube_x.cluster.adminUser.password ) }}
{{- range .Values.kube_x.traefik.middleware.basicAuth.users }}
{{- $result = append $result (b64enc .) }}
{{- end }}
{{- join "\n" $result }}
{{- end }}
