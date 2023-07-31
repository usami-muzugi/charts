{{- define "ninja.secret" -}}
  {{- $fullname := (include "ix.v1.common.lib.chart.names.fullname" $) -}}

  {{- $appKey := randAlphaNum 32 -}}
  {{- with (lookup "v1" "Secret" .Release.Namespace (printf "%s-ninja-creds" $fullname)) -}}
    {{- $appKey = ((index .data "APP_KEY") | b64dec) -}}
  {{- end }}
secret:
  ninja-creds:
    enabled: true
    data:
      APP_KEY: {{ $appKey }}
{{- end -}}
