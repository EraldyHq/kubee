{{/*
Return the name of the grafana secret
*/}}
{{- define "external-secrets-vault-secret-name" }}
{{- printf "%s-vault-api-token" (include "kubee-name-prefix" (dict "Release" $.Release "Values" $.Values.kubee ))}}
{{- end }}

{{/*
Return the key of the api token in the secret
*/}}
{{- define "external-secrets-vault-secret-key" }}
{{- printf "api-token" -}}
{{- end }}

