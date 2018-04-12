Write-Host "`nupdating elastic license ...`n"
Invoke-Expression "& { docker-compose --no-ansi -p proxy -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE exec elk-elasticsearch /update-license.sh }"

exit
