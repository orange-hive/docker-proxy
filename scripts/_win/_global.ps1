if (-Not (Test-Path "$env:CWD\.env")) {
    throw "Environment File missing. Use setup command to create it."
}

if (-Not (Test-Path "$env:CWD\docker-data\config")) {
    throw "docker-data\config is missing. Use setup command to create it."
}

$lines = cat .env
foreach ($line in $lines) {
    if (-Not ($line.StartsWith('#'))) {
        $parts = $line.Split('=')
        if ($parts.Length -eq 2) {
            [Environment]::SetEnvironmentVariable($parts[0], $parts[1])
        }
    }
}

if ($env:PRODUCTION -eq "1" -And -Not (Test-Path "$env:CWD\docker-data\config\container\elasticsearch\license.json")) {
    throw "Elastic license File missing. Please create one. (docker-data\config\container\elasticsearch\license.json)"
}

$ADDITIONAL_CONFIGFILE = ""

if ($env:PROXY_PORT_SSL) {
    Write-Host "adding ssl configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.ssl.yml"
}

if ($env:LETSENCRYPT -eq "1") {
    if (-Not $env:PROXY_PORT_SSL) {
        throw "PROXY_PORT_SSL not set, but needed for letsencrypt"
    }
    Write-Host "adding letsencrypt configuration"
    ADDITIONAL_CONFIGFILE=$ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.letsencrypt.yml"
}

if ($env:PRODUCTION -eq "1") {
    Write-Host "adding production configuration"
    ADDITIONAL_CONFIGFILE=$ADDITIONAL_CONFIGFILE + " -f docker-data/config/base/docker-compose.production.yml"
}

if (Test-Path $env:CWD\docker-data\config\docker-compose.custom.yml) {
    Write-Host "adding custom configuration"
    $ADDITIONAL_CONFIGFILE = $ADDITIONAL_CONFIGFILE + " -f docker-data\config\docker-compose.custom.yml"
}

[Environment]::SetEnvironmentVariable('COMPOSE_CONVERT_WINDOWS_PATHS', 1)
