
$ADDITIONAL_CONFIGFILE = ""
$DEGUBGMODE = 0
for ( $i = 0; $i -lt $args.count; $i++ ) {
    if ($args[$i] -eq "-d") {
        $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\base\docker-compose.debug.yml"
        Write-Host "***DEBUGMODE***`n"
        $DEBUGMODE = 1
    } else {
        throw "invalid parameter " + $args[$i]
    }
}

if ($env:PROXY_PORT_SSL) {
    Write-Host "adding ssl configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.ssl.yml"
}

if ($env:LETSENCRYPT -eq "1") {
    if (-Not $env:PROXY_PORT_SSL) {
        throw "PROXY_PORT_SSL not set, but needed for letsencrypt"
    }
    Write-Host "adding letsencrypt configuration"
    ADDITIONAL_CONFIGFILE=$ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.letsencrypt.yml"
}

if ($DEBUGMODE -eq "0" -And $env:PRODUCTION -eq "1") {
    Write-Host "adding production configuration"
    ADDITIONAL_CONFIGFILE=$ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.production.yml"
}

if (Test-Path $env:CWD\docker-data\config\docker-compose.custom.yml) {
    Write-Host "adding custom configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\docker-compose.custom.yml"
}

if ($env:AUTOPULL -eq "1") {
    Write-Host "`nupdating container images if needed ..."
    Invoke-Expression "& { docker-compose -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"
}

Write-Host "`nstarting proxy ..."
Out-File -Encoding ascii -FilePath docker-data\config\container\nginx\htpasswd\docker-ui
Out-File -Encoding ascii -FilePath docker-data\config\container\nginx\htpasswd\kibana
Invoke-Expression "& { docker-compose -p proxy -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE up -d }"

if ($DEBUGMODE -eq "0") {
    Write-Host "`nsetting passwords ..."
    Invoke-Expression "& { docker-compose -p proxy -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE exec nginx /update-htpasswd.sh elastic `"$env:ELASTIC_PASSWORD`" `"docker-ui.$env:BASE_DOMAIN`" }"
    Invoke-Expression "& { docker-compose -p proxy -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE exec nginx /update-htpasswd.sh elastic `"$env:ELASTIC_PASSWORD`" `"kibana.$env:BASE_DOMAIN`" }"
}

Write-Host "done`n"

exit
