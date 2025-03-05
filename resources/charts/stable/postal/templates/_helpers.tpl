
{{/*
Helper to print the basic name for consistency
*/}}
{{- define "postal-name" }}
{{- printf "%s"
    (include "kubee-name-prefix" (dict "Release" .Release "Values" .Values.kubee ))
    }}
{{- end }}

{{/* Config Map name*/}}
{{- define "postal-name-config-map" }}
{{- printf "%s" (include "kubee-name" (mergeOverwrite . (dict "component" "config")))}}
{{- end }}

{{/* Config Secret name*/}}
{{- define "postal-name-config-secret" }}
{{- printf "%s" (include "kubee-name" (mergeOverwrite . (dict "component" "config") .))}}
{{- end }}

{{/* Config Tls secret name*/}}
{{- define "postal-name-tls" }}
{{- printf "%s" (include "kubee-name" (mergeOverwrite . (dict "component" "tls") ))}}
{{- end }}

{{/* Config checksum*/}}
{{- define "postal-config-checksum-annotation" }}
{{ printf "postal-config/checksum: %s" (include (print .Template.BasePath "/config/postal-config-map.yaml") . | sha256sum )}}
{{- end }}