
if ($args[0]) {
    $CONTAINER = $args[0]
} else {
    $CONTAINER = "logstash"
}

Invoke-Expression "& { docker-compose --no-ansi -p proxy -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE logs -f --tail='50' $CONTAINER }"

exit
