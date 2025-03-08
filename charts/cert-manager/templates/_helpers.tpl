{{/*
Return the name of the cloudflare secret
*/}}
{{- define "cert-manager-cloudflare-secret-name" }}
{{- printf "%s-cloudflare-dns-api-token" (include "kubee-name-prefix" (dict "Release" $.Release "Values" $.Values.kubee ))}}
{{- end }}


{{/*
Return the key of the cloudflare api token in the secret
*/}}
{{- define "cert-manager-kubee-ca-name" }}
{{- printf "kubee-ca" -}}
{{- end }}