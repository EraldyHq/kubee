
{{/*
Helper to print the basic name for consitency
*/}}
{{- define "postal-name" }}
{{- printf "%s"
    (include "kubee-name-prefix" (dict "Release" .Release "Values" .Values.kubee ))
    }}
{{- end }}

{{/* Config name*/}}
{{- define "postal-name-config" }}
{{- printf "%s" (include "kubee-name" (merge . (dict "component" "config")))}}
{{- end }}