{{/*
Return the name of the cloudflare secret
*/}}
{{- define "cert-manager-cloudflare-secret-name" }}
{{- printf "%s-cloudflare-dns-api-key" (include "kube-x-name-prefix" (dict "Release" $.Release "Values" $.Values.kube_x ))}}
{{- end }}

{{/*
Return the key of the cloudflare api token in the secret
*/}}
{{- define "cert-manager-cloudflare-secret-key" }}
{{- printf "api-token" -}}
{{- end }}
