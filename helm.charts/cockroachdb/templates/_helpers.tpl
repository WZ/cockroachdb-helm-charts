{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "cockroachdb.networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <=1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "^1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "cockroachdb.serviceAccountName" -}}
{{- if .Values.Secure.ServiceAccount.Create -}}
    {{ default (printf "%s-%s" .Release.Name .Values.Name | trunc 56) .Values.Secure.ServiceAccount.Name }}
{{- else -}}
    {{ default "default" .Values.Secure.ServiceAccount.Name }}
{{- end -}}
{{- end -}}

{{- define "cockroachdb.publicServiceName" -}}
  {{ printf "%s-%s" .Release.Name .Values.Name | trunc 56 }}-public
{{- end -}}

{{- define "cockroachdb.fullName" -}}
  {{ printf "%s-%s" .Release.Name .Values.Name | trunc 56 }}
{{- end -}}