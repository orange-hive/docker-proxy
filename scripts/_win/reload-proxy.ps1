Write-Host "`nreloading proxy ...`n"
Invoke-Expression "& { docker-compose --no-ansi -p proxy -f docker-data\config\base\docker-compose.yml exec nginx nginx -s reload }"

exit
