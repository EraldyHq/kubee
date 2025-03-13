{{/*
Library of templates created with the define keyword
https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template
*/}}



{{define "external-dns-provider-secret-name" }}
{{- trim (include "kubee-name" .)}}
{{end }}


{{define "external-dns-container-security-context"}}
allowPrivilegeEscalation: false
capabilities:
  drop:
    - ALL
privileged: false
readOnlyRootFilesystem: true
runAsGroup: 65532
runAsNonRoot: true
runAsUser: 65532
{{end}}
