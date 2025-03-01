
{{/*
Helper to print the basic name for consitency
*/}}
{{- define "postal-name" }}
{{- printf "%s"
    (include "kubee-name-prefix" (dict "Release" .Release "Values" .Values.kubee ))
    }}
{{- end }}

