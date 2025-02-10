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
include "kubee-name-prefix" (dict "Release" .Release "Values" .Values.kubee )
*/}}
{{- define "kubee-name-prefix" }}
{{- printf "%s-%s" .Release.Name (include "kubee-prefix" .)  | replace "_" "-" | trunc 63 -}}
{{- end }}


{{/*
Return the name of the traefik basic auth
Name is fixed and does not depend on the release
*/}}
{{- define "kubee-traefik-basic-auth-name" }}
{{- printf "%s-traefik-middleware-basic-auth" (include "kubee-prefix" .) -}}
{{- end }}

{{/*
Return the name of the traefik transport that can be used as label
*/}}
{{- define "kubee-traefik-basic-auth-label-name" }}
{{- printf "%s-%s@kubernetescrd"
    .Values.traefik.namespace
    (include "kubee-traefik-basic-auth-name" .)
-}}
{{- end }}


{{/*
Return the name of the github allow list middelware (used on ingress)
Name is fixed and does not depend on the release
*/}}
{{- define "kubee-traefik-github-hooks-allow-list-name" }}
{{- printf "%s-traefik-ip-allow-github-hooks-cidr" (include "kubee-prefix" .) -}}
{{- end }}