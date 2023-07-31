{{- define "ninja.persistence" -}}
persistence:
  public:
    enabled: true
    type: {{ .Values.ninjaStorage.public.type }}
    datasetName: {{ .Values.ninjaStorage.public.datasetName | default "" }}
    hostPath: {{ .Values.ninjaStorage.public.hostPath | default "" }}
    targetSelector:
      ninja:
        readarr:
          mountPath: /var/www/app/public
        01-permissions:
          mountPath: /mnt/directories/public
  storage:
    enabled: true
    type: {{ .Values.ninjaStorage.storage.type }}
    datasetName: {{ .Values.ninjaStorage.storage.datasetName | default "" }}
    hostPath: {{ .Values.ninjaStorage.storage.hostPath | default "" }}
    targetSelector:
      ninja:
        readarr:
          mountPath: /var/www/app/storage
        01-permissions:
          mountPath: /mnt/directories/storage
  tmp:
    enabled: true
    type: emptyDir
    targetSelector:
      readarr:
        readarr:
          mountPath: /tmp
  {{- range $idx, $storage := .Values.readarrStorage.additionalStorages }}
  {{ printf "readarr-%v" (int $idx) }}:
    enabled: true
    type: {{ $storage.type }}
    datasetName: {{ $storage.datasetName | default "" }}
    hostPath: {{ $storage.hostPath | default "" }}
    targetSelector:
      readarr:
        readarr:
          mountPath: {{ $storage.mountPath }}
        01-permissions:
          mountPath: /mnt/directories{{ $storage.mountPath }}
  {{- end }}
{{- end -}}
