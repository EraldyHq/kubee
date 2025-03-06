
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

{{/*# https://helm.sh/docs/chart_template_guide/named_templates/#declaring-and-using-templates-with-define-and-template*/}}
{{- define "postal-deploy-containers-common" }}
    image: "ghcr.io/postalserver/postal:{{ .Values.version }}"
    env:
      - name: SMTP_HOST
        value: '{{.Values.conf_kube.smtp_server.service_name}}.{{.Values.namespace}}.svc.cluster.local'
      - name: SMTP_PORT
        value: '{{.Values.conf_kube.smtp_server.port}}'
      - name: MAIN_DB_HOST
        value: '{{.Values.conf_kube.main_db.service_name}}.{{.Values.namespace}}.svc.cluster.local'
      - name: MAIN_DB_PORT
        value: '{{.Values.conf_yaml.main_db.port}}'
      - name: MAIN_DB_USERNAME
        value: '{{.Values.conf_yaml.main_db.username}}'
      - name: MAIN_DB_PASSWORD
        valueFrom:
          secretKeyRef:
            name: {{ include "postal-name-config-secret" . }}
            key: mariadb-password
      - name: MESSAGE_DB_HOST
        value: '{{.Values.conf_kube.main_db.service_name}}.{{.Values.namespace}}.svc.cluster.local'
      - name: MESSAGE_DB_PORT
        value: '{{.Values.conf_yaml.main_db.port}}'
      - name: MESSAGE_DB_USERNAME
        value: {{.Values.conf_yaml.main_db.username}}
      - name: MESSAGE_DB_PASSWORD
        valueFrom:
          secretKeyRef:
            name: {{ include "postal-name-config-secret" . }}
            key: mariadb-password
      - name: RAILS_SECRET_KEY
        valueFrom:
          secretKeyRef:
            name: {{ include "postal-name-config-secret" . }}
            key: rails-secret-key
    volumeMounts:
      - name: config-map
        mountPath: /config/postal.yml
        subPath: postal.yml
        readOnly: true
      - name: smtp-tls
        mountPath: /config/certs
        readOnly: true
volumes:
  - name: config-map
    configMap:
      name: {{ include "postal-name-config-map" . }}
  - name: smtp-tls
    secret:
      secretName: '{{ include "postal-name-tls" . }}'
  - name: config-secret
    secret:
      secretName: '{{ include "postal-name-config-secret" . }}'
{{- end }}