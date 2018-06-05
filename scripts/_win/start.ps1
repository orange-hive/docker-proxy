
if ($env:AUTOPULL -eq "1") {
    Write-Host "`nupdating container images if needed ..."
    Invoke-Expression "& { docker-compose --no-ansi -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE pull }"
}

Write-Host "`nstarting proxy ..."
Out-File -Encoding ascii -FilePath docker-data\config\container\nginx\htpasswd\docker-ui
Out-File -Encoding ascii -FilePath docker-data\config\container\nginx\htpasswd\kibana
Invoke-Expression "& { docker-compose --no-ansi -p proxy -f docker-data\config\base\docker-compose.yml $ADDITIONAL_CONFIGFILE up -d }"

if ($env:PRODUCTION -eq "1") {
    Write-Host "`nsetting passwords ..."
}

Write-Host "done`n"

exit
