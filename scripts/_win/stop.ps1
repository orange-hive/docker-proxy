
Invoke-Expression "& { docker-compose --no-ansi -p proxy -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE down }"
Out-File -Encoding ascii -FilePath docker-data\config\container\nginx\htpasswd\docker-ui
Out-File -Encoding ascii -FilePath docker-data\config\container\nginx\htpasswd\kibana

exit
