if (-Not (Test-Path "$env:CWD\.env")) {
    throw "Environment File missing. Rename .env-dist to .env and customize it before starting this project."
}

if (-Not (Test-Path "$env:CWD\docker-data\config")) {
    throw "docker-data\config is missing. Rename docker-data\config-dist to docker-data\config and customize it before starting this project."
}

if (-Not (Test-Path "$env:CWD\docker-data\config\container\elasticsearch\license.json")) {
    throw "Elastic license File missing. Please create one. (docker-data\config\container\elasticsearch\license.json)"
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
