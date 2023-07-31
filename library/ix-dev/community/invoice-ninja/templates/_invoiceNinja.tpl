{{- define "ninja.workload" -}}
workload:
  ninja:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      securityContext:
        fsGroup: 1500
      hostNetwork: {{ .Values.ninjaNetwork.hostNetwork }}
      containers:
        ninja:
          enabled: true
          primary: true
          imageSelector: image
          securityContext:
            runAsUser: 1500
            runAsGroup: 1500
          env:
            APP_ENV: production
          envFrom:
            - secretRef:
                name: ninja-creds
          {{ with .Values.ninjaConfig.additionalEnvs }}
          envList:
            {{ range $env := . }}
            - name: {{ $env.name }}
              value: {{ $env.value }}
            {{ end }}
          {{ end }}
          probes:
            liveness:
              enabled: true
              type: tcp
              port: 9000
            readiness:
              enabled: true
              type: tcp
              port: 9000
            startup:
              enabled: true
              type: tcp
              port: 9000
      initContainers:
      {{- include "ix.v1.common.app.permissions" (dict "containerName" "01-permissions"
                                                        "UID" 1500
                                                        "GID" 1500
                                                        "mode" "check"
                                                        "type" "init") | nindent 8 }}
{{- end -}}
