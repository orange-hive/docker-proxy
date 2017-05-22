Write-Host "`nchecking proxy config ...`n"
Invoke-Expression "& { docker-compose -p proxy -f docker-data\config\base\docker-compose.yml exec nginx nginx -t }"

exit
