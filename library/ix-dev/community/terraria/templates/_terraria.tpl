{{- define "terraria.workload" -}}
workload:
  terraria:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      hostNetwork: {{ .Values.terrariaNetwork.hostNetwork }}
      containers:
        terraria:
          enabled: true
          primary: true
          imageSelector: {{ .Values.terrariaConfig.imageSelector }}
          tty: true
          stdin: true
          args:
          {{- include "terraria.configuration" $ | nindent 12 }}
          securityContext:
            runAsUser: 0
            runAsGroup: 0
            runAsNonRoot: false
            readOnlyRootFilesystem: false
          {{ with .Values.terrariaConfig.additionalEnvs }}
          envList:
            {{ range $env := . }}
            - name: {{ $env.name }}
              value: {{ $env.value }}
            {{ end }}
          {{ end }}
          probes:
            # Probes are disabled because it fills the logs with
            # "login attemps"
            liveness:
              enabled: {{ .Values.ci }}
              type: tcp
              port: "{{ .Values.terrariaNetwork.serverPort }}"
            readiness:
              enabled: {{ .Values.ci }}
              type: tcp
              port: "{{ .Values.terrariaNetwork.serverPort }}"
            startup:
              enabled: {{ .Values.ci }}
              type: tcp
              port: "{{ .Values.terrariaNetwork.serverPort }}"

{{/* Service */}}
service:
  terraria:
    enabled: true
    primary: true
    type: NodePort
    targetSelector: terraria
    ports:
      server:
        enabled: true
        primary: true
        port: {{ .Values.terrariaNetwork.serverPort }}
        nodePort: {{ .Values.terrariaNetwork.serverPort }}
        targetSelector: terraria

{{/* Persistence */}}
persistence:
  world:
    enabled: true
    type: {{ .Values.terrariaStorage.world.type }}
    datasetName: {{ .Values.terrariaStorage.world.datasetName | default "" }}
    {{- with .Values.terrariaStorage.world.hostPath }}
    hostPath: {{ . }}
    {{- end }}
    targetSelector:
      terraria:
        terraria:
          mountPath: /root/.local/share/Terraria/Worlds
  plugins:
    enabled: true
    type: {{ .Values.terrariaStorage.plugins.type }}
    datasetName: {{ .Values.terrariaStorage.plugins.datasetName | default "" }}
    {{- with .Values.terrariaStorage.plugins.hostPath }}
    hostPath: {{ . }}
    {{- end }}
    targetSelector:
      terraria:
        terraria:
          mountPath: /plugins
{{- end -}}
