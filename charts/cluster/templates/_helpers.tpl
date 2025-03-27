{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}

{{/*
    Prefix used to see who has created an object,
    We may also use a label by the way
    (Variables are scoped to a template, that's why we use a function)
*/}}
{{- define "kubee-prefix" }}
{{- printf "kubee" }}
{{- end }}





{{/*
Return a name prefix created from the release
Usage in a sub-chart
include "kubee-name-prefix" .
include "kubee-name-prefix" (dict "Release" $.Release )
*/}}
{{- define "kubee-name-prefix" }}
{{- printf "%s-%s" .Release.Name (include "kubee-prefix" .)  | replace "_" "-" | trunc 63 -}}
{{- end }}


{{- define "kubee-to-camel-case"}}
{{- $word := . -}}
{{- $firstUpperCaseLetter := upper (substr 0 1 $word) -}}
{{- $restOfString := substr 1 (len $word) $word -}}
{{- printf "%s%s" $firstUpperCaseLetter $restOfString -}}
{{- end }}

{{/* Return the apex domain */}}
{{- define "kubee-get-apex-domain"}}
{{- $name := . -}}
{{- regexReplaceAll "^(.*\\.)?([^.]+\\.[^.]+)$" $name "$2" }}
{{- end }}



{{/*
    Return the labels for a manifest
    https://helm.sh/docs/chart_best_practices/labels/#standard-labels
    Component name should be a property
    Usage Example:
    {{- include "kubee-manifest-labels" (merge . (dict "component" "web")) }}
    or
    {{ $ := mergeOverwrite $ (dict "component" "cloudflare") }}
    {{- include "kubee-manifest-labels" $ | indent 4}}
    
    app/name is used by old cli as default such as kubenav for pod selection of Prometheus
*/}}
{{- define "kubee-manifest-labels" }}
{{ printf "app/name: %s" (required "app.kubernetes.io/name annotation is required in Chart.yaml" (index .Chart.Annotations "app.kubernetes.io/name")) }}
{{ printf "app.kubernetes.io/name: %s" (required "app.kubernetes.io/name annotation is required in Chart.yaml" (index .Chart.Annotations "app.kubernetes.io/name")) }}
{{- if hasKey . "component" }}
{{ printf "app.kubernetes.io/component: %s" (required "component property is required " .component)}}
{{- end }}
{{ printf "app.kubernetes.io/instance: %s" .Release.Name }}
{{ printf "app.kubernetes.io/version: %s" .Chart.AppVersion }}
{{ printf "app.kubernetes.io/managed-by: %s" .Release.Service }}
{{ printf "helm.sh/chart: %s-%s" .Chart.Name (.Chart.Version | replace "+" "_") }}
{{- end }}

{{/*
    Return the labels for a pod
    https://helm.sh/docs/chart_best_practices/labels/#standard-labels
    Component name should be a property
    App version is not needed to make the pod unique as it's part of the Release Name
    Usage Example:
    {{- include "kubee-pod-labels" (merge . (dict "component" "web")) }}
*/}}
{{- define "kubee-pod-labels" }}
{{ printf "app.kubernetes.io/name: %s" (required "app.kubernetes.io/name chart annotation is required " (index .Chart.Annotations "app.kubernetes.io/name")) }}
{{- if hasKey . "component" }}
{{ printf "app.kubernetes.io/component: %s" (required "component property is required " .component)}}
{{- end}}
{{ printf "app.kubernetes.io/instance: %s" .Release.Name }}
{{- end }}

{{/*
    Return the name of an object
    Component name should be a property
    Usage Example:
    {{- include "kubee-name" (dict "Chart" .Chart "component" "web") }}
*/}}
{{- define "kubee-name" }}
{{- $appName := required "app.kubernetes.io/name chart annotation is required " (index .Chart.Annotations "app.kubernetes.io/name")}}
{{- $kubePrefix := include "kubee-prefix" . }}
{{- if hasKey . "component" }}
{{- printf "%s-%s-%s" $appName .component $kubePrefix }}
{{- else }}
{{- printf "%s-%s" $appName $kubePrefix }}
{{- end }}
{{- end }}