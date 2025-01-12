{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}

{{/*
    Prefix used to see who has created an object,
    We may also use a label by the way
    (Variables are scoped to a template, that's why we use a function)
*/}}
{{- define "kube-x-prefix" }}
{{- printf "kube-x" }}
{{- end }}
{{/*
Return a name prefix
Usage in a sub-chart
include "kube-x-name-prefix" (dict "Release" .Release "Values" .Values.kube_x )
*/}}
{{- define "kube-x-name-prefix" }}
{{- printf "%s-%s" .Release.Name (include "kube-x-prefix" .)  | replace "_" "-" | trunc 63 -}}
{{- end }}


{{/*
Return the name of the traefik basic auth
*/}}
{{- define "kube-x-traefik-basic-auth-name" }}
{{- printf "%s-middelware-basic-auth" (include "kube-x-prefix" .) -}}
{{- end }}

{{/*
Return the name of the traefik transport that can be used as label
*/}}
{{- define "kube-x-traefik-basic-auth-label-name" }}
{{- printf "%s-%s@kubernetescrd"
    .Values.traefik.namespace
    (include "kube-x-traefik-basic-auth-name" .)
-}}
{{- end }}


{{/*
Return the name of the github allow list middelware (used on ingress)
Kube-x prefix later
*/}}
{{- define "kube-x-traefik-github-hooks-allow-list-name" }}
{{- printf "ip-allow-github-hooks-cidr" }}
{{- end }}