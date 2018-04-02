Write-Host "`nupdating container images if needed ..."

$ADDITIONAL_CONFIGFILE=""

if ($env:PROXY_PORT_SSL) {
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.ssl.yml"
}

if ($env:LETSENCRYPT -eq "1") {
    ADDITIONAL_CONFIGFILE=$ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.letsencrypt.yml"
}

if ($env:PRODUCTION -eq "1") {
    Write-Host "adding production configuration"
    ADDITIONAL_CONFIGFILE=$ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.production.yml"
}

if (Test-Path "$env:CWD\docker-data\config\docker-compose.custom.yml") {
    $ADDITIONAL_CONFIGFILE = "$ADDITIONAL_CONFIGFILE -f docker-data\config\docker-compose.custom.yml"
}

Invoke-Expression "& { docker-compose --no-ansi -p proxy -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"

exit
