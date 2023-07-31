{{- define "ninja.workload" -}}
workload:
  nginx:
    enabled: true
    type: Deployment
    podSpec:
      securityContext:
        fsGroup: 1500
      hostNetwork: {{ .Values.ninjaNetwork.hostNetwork }}
      containers:
        nginx:
          enabled: true
          primary: true
          imageSelector: image
          securityContext:
            runAsUser: 1500
            runAsGroup: 1500
          probes:
            liveness:
              enabled: true
              type: tcp
              port: {{ .Values.ninjaNetwork.webPort }}
            readiness:
              enabled: true
              type: tcp
              port: {{ .Values.ninjaNetwork.webPort }}
            startup:
              enabled: true
              type: tcp
              port: {{ .Values.ninjaNetwork.webPort }}
          # initContainer: # TODO: wait for ninja
{{- end -}}
