
if ("$args[0]" == "") {
    $CONTAINER = "elk-logstash"
} else {
    $CONTAINER = "$args[0]"
fi

if (Test-Path $env:CWD\docker-data\config\docker-compose.custom.yml) {
    Write-Host "adding custom configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\docker-compose.custom.yml"
}

Invoke-Expression "& { docker-compose -p proxy -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE logs -f --tail='50' $CONTAINER }"

exit
