Write-Host "`nupdating container images if needed ..."
Invoke-Expression "& { docker-compose -p proxy -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"

exit
