
{{/*
Name of the pvc
*/}}
{{- define "pushgateway-pvc-name" }}{{ include "kubee-name" (dict "Chart" .Chart "component" "pvc")}}{{- end }}
