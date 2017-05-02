Write-Host "`nupdating container images if needed ..."
Invoke-Expression "& { docker-compose -p `"$env:PROJECTNAME`" -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"

exit
