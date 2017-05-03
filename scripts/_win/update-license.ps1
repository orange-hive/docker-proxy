Write-Host "`nupdating elastic license ...`n"
Invoke-Expression "& { docker-compose -p proxy -f docker-data\config\base\docker-compose.yml exec elk-elasticsearch /update-license.sh }"

exit
