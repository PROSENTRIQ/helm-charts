{{- define "agent.name" -}}{{ .Release.Name }}{{- end -}}
{{- define "agent.labels" -}}
app.kubernetes.io/name: prosentriq-agent
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end -}}
{{- define "agent.secret" -}}{{ .Values.existingSecret | default (printf "%s-enroll" (include "agent.name" .)) }}{{- end -}}
