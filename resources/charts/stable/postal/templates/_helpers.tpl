
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
{{ printf "postal-config/map-checksum: %s" (include (print .Template.BasePath "/config/postal-config-map.yaml") . | sha256sum )}}
{{ printf "postal-config/secret-checksum: %s" (include (print .Template.BasePath "/config/postal-config-secret.yaml") . | sha256sum )}}
{{- end }}

{{- /*
Merge a YAML file with a Helm values map
Params:
- $values: The Helm values map
- $filename: Path to the YAML file to merge
- $context: The context to use for rendering (usually $ or .)

Example Usage in values.yaml or templates:
my-config:
    {{ include "utils.mergeYaml" (list .Values.myBaseConfig "configs/default-config.yaml" $) | indent 2 }}
*/ -}}
{{- define "utils.mergeYaml" -}}
    {{- $values := index . 0 -}}
    {{- $filename := index . 1 -}}
    {{- $context := index . 2 -}}

    {{- $fileContent := "" -}}
    {{- if $context.Files.Get $filename -}}
        {{- $fileContent = $context.Files.Get $filename | fromYaml -}}
    {{- else -}}
        {{- fail (printf "File not found: %s" $filename) -}}
    {{- end -}}

    {{- $merged := mustMergeOverwrite $values -}}
    {{- $merged | toYaml -}}
{{- end -}}

{{- /*
Deep merge function for nested tree structures
Params:
- $base: Base tree/dictionary to merge into
- $overlay: Overlay tree/dictionary to merge from
 Example Usage in templates or values files
{{ include "utils.deepMerge" (list .Values.baseConfig .Values.overlayConfig) | indent 2 }}
*/ -}}
{{- define "utils.deepMerge" -}}
    {{- $base := index . 0 -}}
    {{- $overlay := index . 1 -}}

    {{- if kindIs "map" $base -}}
        {{- range $key, $overlayValue := $overlay -}}
            {{- $baseValue := get $base $key -}}

            {{- if eq $baseValue nil -}}
                {{/* If key doesn't exist in base, set directly */}}
                {{- $_ := set $base $key $overlayValue -}}
            {{- else if and (kindIs "map" $baseValue) (kindIs "map" $overlayValue) -}}
                {{/* Recursively merge nested maps */}}
                {{- $mergedValue := include "utils.deepMerge" (list $baseValue $overlayValue) | fromYaml -}}
                {{- $_ := set $base $key $mergedValue -}}
            {{- else -}}
                {{/* For non-map values, overlay replaces base */}}
                {{- $_ := set $base $key $overlayValue -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}

    {{- $base | toYaml -}}
{{- end -}}