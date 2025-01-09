{{/*
Return the name of the notifications secret
Fixed: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/#getting-started
Don't change it
*/}}
{{- define "kube-x-argocd-notifications-secret-name" }}
{{- printf "argocd-notifications-secret"}}
{{- end }}

{{/*
Return the name of the email username variable
*/}}
{{- define "kube-x-argocd-email-username-variable-name" }}
{{- printf "smtp-username"}}
{{- end }}

{{/*
Return the name of the email password variable
*/}}
{{- define "kube-x-argocd-email-password-variable-name" }}
{{- printf "smtp-password"}}
{{- end }}
