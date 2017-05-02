$ADDITIONAL_CONFIGFILE=""

if ($env:PROXY_PORT_SSL) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.ssl.yml"
}

if ($env:LETSENCRYPT -eq "1") {
    ADDITIONAL_CONFIGFILE=$ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.letsencrypt.yml"
}

if (Test-Path "$env:CWD\docker-data\config\docker-compose.custom.yml") {
    $ADDITIONAL_CONFIGFILE = "$ADDITIONAL_CONFIGFILE -f docker-data\config\docker-compose.custom.yml"
}

docker-compose -p proxy -f docker-data\config\base\docker-compose.yml -f docker-data\config\base\docker-compose.debug.yml $ADDITIONAL_CONFIGFILE down
Out-File -Encoding ascii -FilePath docker-data\config\container\nginx\htpasswd\docker-ui
Out-File -Encoding ascii -FilePath docker-data\config\container\nginx\htpasswd\kibana

exit
