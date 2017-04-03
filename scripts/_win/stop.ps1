$ADDITIONAL_CONFIGFILE=""

if ($env:PROXY_PORT_SSL) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.ssl.yml"
}

if [ $env:LETSENCRYPT -eq "1" ]; then
    ADDITIONAL_CONFIGFILE=$ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.letsencrypt.yml"
fi

if (Test-Path "$env:CWD\docker-data\config\docker-compose.custom.yml") {
    $ADDITIONAL_CONFIGFILE = "$ADDITIONAL_CONFIGFILE -f docker-data\config\docker-compose.custom.yml"
}

docker-compose -p proxy -f docker-data\config\base\docker-compose.yml -f docker-data\config\base\docker-compose.denug.yml $ADDITIONAL_CONFIGFILE down

exit
