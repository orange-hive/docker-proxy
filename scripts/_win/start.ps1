
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

if (Test-Path $env:CWD\docker-data\config\docker-compose.custom.yml) {
    Write-Host "adding custom configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\docker-compose.custom.yml"
}

Write-Host "`nupdating container images if needed ..."
Invoke-Expression "& { docker-compose -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"

Write-Host "`nstarting proxy ..."
Invoke-Expression "& { docker-compose -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE up -d }"

Write-Host "done`n"

exit
