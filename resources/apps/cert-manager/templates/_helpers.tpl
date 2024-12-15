{{/*
Return the name of the cloudlkare secret
*/}}
{{- define "cert-manager-cloudflare-secret-name" }}
{{- printf "%s-cloudflare-dns-api-key" .Release.Name -}}
{{- end }}

{{- define "cert-manager-cloudflare-secret-key" }}
{{- printf "api-token" -}}
{{- end }}
