{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}


{{define "external-dns-cloudflare-secret-name" }}
{{- include "kubee-name" (mergeOverwrite . (dict "component" "cloudflare")) }}
{{end }}


{{define "external-dns-provider-secret-name" }}
{{- include "kubee-name" (mergeOverwrite . (dict "component" .Values.provider)) }}
{{end }}

{{define "external-dns-provider-name" }}
{{if ne .Values.provider.name ""}}
.Values.provider.name
{{else if or (gt (len .Values.cluster.dns.cloudflare.dns_zones) 0) (ne .Values.cluster.dns.cloudflare.api_token "")}}
cloudflare-cluster
{{else if eq .Values.provider.type "in-tree"}}
{{ fail "For an intree provider the provider name is required"}}
{{end}}
{{end}}