{{- define "ninja.configmap" -}}
configmap:
  nginx-config:
    enabled: true
    data:
      nginx.conf: |
        server {
            listen {{ .Values.ninjaNetwork.webPort }} default_server;
            server_name _;

            root /app;
            index index.php;

            location / {
                try_files $uri $uri/ /index.php?$query_string;
            }

            location = /favicon.ico { access_log off; log_not_found off; }
            location = /robots.txt  { access_log off; log_not_found off; }

            location ~ \.php$ {
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass {{ include "ix.v1.common.lib.chart.names.fullname" $ }}:9000;
                fastcgi_index index.php;
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME /var/www/app/public$fastcgi_script_name;
                fastcgi_buffer_size 16k;
                fastcgi_buffers 4 16k;
            }
        }
  ninja:
    enabled: true
    data:
      DB_TYPE:
{{- end -}}
