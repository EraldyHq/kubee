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


