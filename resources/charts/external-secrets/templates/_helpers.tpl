{{/*
Return the name of the grafana secret
*/}}
{{- define "external-secrets-vault-secret-name" }}
{{- printf "%s-vault-api-token" (include "kube-x-name-prefix" (dict "Release" $.Release "Values" $.Values.kube_x ))}}
{{- end }}

{{/*
Return the key of the api token in the secret
*/}}
{{- define "external-secrets-vault-secret-key" }}
{{- printf "api-token" -}}
{{- end }}

