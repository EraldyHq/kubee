{{/*
Return the name of the grafana secret
*/}}
{{- define "grafana-instance-api-token-secret-name" }}
{{- printf "%s-grafana-api-token" (include "kubee-name-prefix" (dict "Release" $.Release "Values" $.Values.kubee ))}}
{{- end }}

{{/*
Return the key of the api token in the secret
*/}}
{{- define "grafana-instance-api-token-secret-key" }}
{{- printf "api-token" -}}
{{- end }}

{{/*
Helper to print the basic auth name for consitency
(used for middelware, ...)
*/}}
{{- define "grafana-name" }}
{{- printf "%s-%s"
    (include "kubee-name-prefix" (dict "Release" .Release "Values" .Values.kubee ))
    "grafana"
    }}
{{- end }}