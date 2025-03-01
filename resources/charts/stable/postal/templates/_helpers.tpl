
{{/*
Helper to print the basic name for consitency
*/}}
{{- define "postal-name" }}
{{- printf "%s"
    (include "kubee-name-prefix" (dict "Release" .Release "Values" .Values.kubee ))
    }}
{{- end }}

{{/* Config name*/}}
{{- define "postal-name-postal-yml" }}
{{- printf "%s" (include "kubee-name" (merge . (dict "component" "config")))}}
{{- end }}

{{/* Config name*/}}
{{- define "postal-name-config-secret" }}
{{- printf "%s" (include "kubee-name" (merge . (dict "component" "config-secret")))}}
{{- end }}

{{/* Signing Key name*/}}
{{- define "postal-name-signing-key" }}
{{- printf "%s" (include "kubee-name" (merge . (dict "component" "signing-key")))}}
{{- end }}

{{/* Config name*/}}
{{- define "postal-name-tls" }}
{{- printf "%s" (include "kubee-name" (merge . (dict "component" "tls")))}}
{{- end }}

{{/* Config checksum*/}}
{{- define "postal-config-checksum-annotation" }}
{{ printf "postal-config/checksum: %s" (include (print .Template.BasePath "/config/postal-postal.yaml") . | sha256sum )}}
{{- end }}