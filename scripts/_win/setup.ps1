if (-Not (Test-Path "$env:CWD\docker-data\config")) {
    Rename-Item -path "$env:CWD\docker-data\config-dist" -newName "$env:CWD\docker-data\config"
}

if (-Not (Test-Path "$env:CWD\.env")) {
    Copy-Item -path "$env:CWD\.env-dist" -Destination "$env:CWD\.env"

    do {
        $PROXY_PORT = Read-Host -Prompt 'PROXY_PORT [80]'
        if (-Not ($PROXY_PORT)) {
            $PROXY_PORT = '80'
        }
        (Get-Content "$env:CWD\.env") -replace 'PROXY_PORT=.*', "PROXY_PORT=$PROXY_PORT" | Set-Content "$env:CWD\.env"
    } while (-Not ($PROXY_PORT))

    $PROXY_PORT_SSL = Read-Host -Prompt 'PROXY_PORT_SSL'
    (Get-Content "$env:CWD\.env") -replace 'PROXY_PORT_SSL=.*', "PROXY_PORT_SSL=$PROXY_PORT_SSL" | Set-Content "$env:CWD\.env"

    $boolean_values = '0','1'
    do {
        $LETSENCRYPT = Read-Host -Prompt 'LETSENCRYPT (1, [0])'
        if (-Not ($LETSENCRYPT)) {
            $LETSENCRYPT = '0'
        }
        (Get-Content "$env:CWD\.env") -replace 'LETSENCRYPT=.*', "LETSENCRYPT=$LETSENCRYPT" | Set-Content "$env:CWD\.env"
    } while (-Not $boolean_values -match $LETSENCRYPT)

    do {
        $ELASTIC_PASSWORD = Read-Host -Prompt 'ELASTIC_PASSWORD'
        (Get-Content "$env:CWD\.env") -replace 'ELASTIC_PASSWORD=.*', "ELASTIC_PASSWORD=$ELASTIC_PASSWORD" | Set-Content "$env:CWD\.env"
    } while (-Not ($ELASTIC_PASSWORD))

    $boolean_values = '0','1'
    do {
        $AUTOPULL = Read-Host -Prompt 'AUTOPULL (1, [0])'
        if (-Not ($AUTOPULL)) {
            $AUTOPULL = '0'
        }
        (Get-Content "$env:CWD\.env") -replace 'AUTOPULL=.*', "AUTOPULL=$AUTOPULL" | Set-Content "$env:CWD\.env"
    } while (-Not $boolean_values -match $AUTOPULL)

    do {
        $LICENSE_EMAIL = Read-Host -Prompt 'LICENSE_EMAIL'
        (Get-Content "$env:CWD\.env") -replace 'LICENSE_EMAIL=.*', "LICENSE_EMAIL=$LICENSE_EMAIL" | Set-Content "$env:CWD\.env"
    } while (-Not ($LICENSE_EMAIL))

    do {
        $LICENSE_WARN_DAYS = Read-Host -Prompt "LICENSE_WARN_DAYS [60]"
        if (-Not ($LICENSE_WARN_DAYS)) {
            $LICENSE_WARN_DAYS = '60'
        }
        (Get-Content "$env:CWD\.env") -replace 'LICENSE_WARN_DAYS=.*', "LICENSE_WARN_DAYS=$LICENSE_WARN_DAYS" | Set-Content "$env:CWD\.env"
    } while (-Not ($LICENSE_WARN_DAYS))

    $boolean_values = '0','1'
    do {
        $PRODUCTION = Read-Host -Prompt 'PRODUCTION (1, [0])'
        if (-Not ($PRODUCTION)) {
            $PRODUCTION = '0'
        }
        (Get-Content "$env:CWD\.env") -replace 'PRODUCTION=.*', "PRODUCTION=$PRODUCTION" | Set-Content "$env:CWD\.env"
    } while (-Not $boolean_values -match $PRODUCTION)

    do {
        $BASE_DOMAIN = Read-Host -Prompt 'BASE_DOMAIN [lvh.me]'
        if (-Not ($BASE_DOMAIN)) {
            $BASE_DOMAIN = 'lvh.me'
        }
        (Get-Content "$env:CWD\.env") -replace 'BASE_DOMAIN=.*', "BASE_DOMAIN=$BASE_DOMAIN" | Set-Content "$env:CWD\.env"
    } while (-Not ($BASE_DOMAIN))

}

Write-Host "setup complete"

exit