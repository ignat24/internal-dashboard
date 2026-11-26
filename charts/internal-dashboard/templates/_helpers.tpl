{{/*
Expand the name of the chart.
*/}}
{{- define "internal-dashboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "internal-dashboard.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "internal-dashboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "internal-dashboard.labels" -}}
helm.sh/chart: {{ include "internal-dashboard.chart" . }}
{{ include "internal-dashboard.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "internal-dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "internal-dashboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "internal-dashboard.api.selectorLabels" -}}
{{ include "internal-dashboard.selectorLabels" . }}
app.kubernetes.io/component: api
{{- end }}

{{- define "internal-dashboard.web.selectorLabels" -}}
{{ include "internal-dashboard.selectorLabels" . }}
app.kubernetes.io/component: web
{{- end }}

{{- define "internal-dashboard.redis.selectorLabels" -}}
{{ include "internal-dashboard.selectorLabels" . }}
app.kubernetes.io/component: redis
{{- end }}
