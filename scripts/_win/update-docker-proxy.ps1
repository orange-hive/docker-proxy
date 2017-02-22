
. $env:CWD\scripts\_win\stop.ps1

$LATEST_TAG = (git ls-remote --tags --refs git@gitlab.orangehive.de:orangehive/docker-proxy.git | Out-String).toString() -replace '.*refs/tags/release-',''
$LATEST_TAG = "$LATEST_TAG" -split "`r`n" | Where-object{$_} | Sort-Object { [regex]::Replace($_, '\d+', { $args[0].Value.PadLeft(20) }) } | Select-Object -Last 1

if (Test-Path "$env:CWD\.version") {
    $CURRENT_VERSION = cat "$env:CWD\.version"
} else {
    $CURRENT_VERSION = "unknown"
}

if ($CURRENT_VERSION -eq $LATEST_TAG) {
    Write-Host "already on latest version ($LATEST_TAG)"
} else {
    $choice = (Read-Host "Upgrade from $CURRENT_VERSION to $LATEST_TAG`? [y/N] " | Out-String).toString()
    $choice = "$choice" -split "`r`n" | Where-object{$_} | Select-Object -Last 1

    if ($choice -eq "y" -Or $choice -eq "Y") {
        Write-Host "checking out release $LATEST_TAG"
        mkdir "$env:CWD\.docker-update" > $null 2>&1

        git clone --branch release-$LATEST_TAG git@gitlab.orangehive.de:orangehive/docker-proxy.git "$env:CWD\.docker-update"

        Remove-Item -Recurse -Force "$env:CWD\.docker-update\.git"

        if (Test-Path "$env:CWD\docker-data") {
            Write-Host "backing up docker-data"
            $date = (get-date -format 'yyyyMMddTHHmmss' | Out-String).toString()
            robocopy "$env:CWD\docker-data" "$env:CWD\docker-data.backup_$date" *.* /s /e > nul 2>&1

            if (Test-Path "$env:CWD\docker-data\config-dist") {
                Remove-Item -Recurse -Force "$env:CWD\docker-data\config-dist"
            }
        }

        Write-Host "updating"
        if (Test-Path "$env:CWD\bin") {
            Remove-Item -Recurse -Force "$env:CWD\bin"
        }
        if (Test-Path "$env:CWD\scripts") {
            Remove-Item -Recurse -Force "$env:CWD\scripts"
        }
        robocopy "$env:CWD\.docker-update" "$env:CWD" *.* /s /e > nul 2>&1
        rRemove-Item -Recurse -Force "$env:CWD\.docker-update"
        Set-Content -Path "$env:CWD\.version" -Value "$LATEST_TAG"
        Write-Host "`nPlease compare your .env file with the .env-dist file to add new or changed entries and look into the config-dist folder also."
    } else {
        Write-Host "not upgrading"
    }
}

exit
