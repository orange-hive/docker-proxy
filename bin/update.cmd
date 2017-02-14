:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

OLDCWD=$(pwd)
CWD="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"
CWD=$(sed 's/.\{4\}$//' <<< "$CWD")
cd "$CWD"

echo "stopping container"
./stop.cmd

LATEST_TAG=$(git ls-remote --tags --refs git@gitlab.orangehive.de:orangehive/docker-proxy.git | awk -F/ ' { print $3 }' | sed "s/release-//" | sort -t. -s -k 1,1n -k 2,2n -k 3,3n | tail -n 1)

if [ -e "$CWD/.version" ]; then
    CURRENT_VERSION=$(cat "$CWD/.version")
else
    CURRENT_VERSION="unknown"
fi

if [ "$CURRENT_VERSION" == "$LATEST_TAG" ]; then
    echo "already on latest version ($LATEST_TAG)"
else
    read -r -p "Upgrade from $CURRENT_VERSION to $LATEST_TAG? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY])
            echo "checking out release $LATEST_TAG"
            mkdir "$CWD/.docker-update"
            cd "$CWD/.docker-update"
            git clone --branch release-$LATEST_TAG git@gitlab.orangehive.de:orangehive/docker-proxy.git .
            rm -Rf .git

            echo "updating"
            cp -R * "$CWD"
            cp -R .[^.]* "$CWD"

            echo "$LATEST_TAG" > "$CWD/.version"

            rm -Rf "$CWD/.docker-update"
            echo "done"
            echo "Please compare your .env file with the .env-dist file to add new or changed entries"
            ;;
        *)
            echo "not updating"
            ;;
    esac
fi

cd "$OLDCWD"
exit


:CMDSCRIPT
setlocal

SET OLDCWD=%cd%
SET CWD=%~dp0
SET CWD=%CWD:~0,-5%
cd "%CWD%"

echo stopping container
stop.cmd

for /f "usebackq delims=" %%v in (`powershell.exe "& { (git ls-remote --tags --refs git@gitlab.orangehive.de:orangehive/docker-proxy.git | Out-String).toString() -replace '.*refs/tags/release-','' -split '\n' | Where-object{$_} | Sort-Object { [regex]::Replace($_, '\d+', { $args[0].Value.PadLeft(20) }) } | Select-Object -Last 1 }"`) DO set "LATEST_TAG=%%v"

if exist "%cd%/.version" (
    set /p CURRENT_VERSION=<"%cd%/.version"
) else (
    set CURRENT_VERSION=unknown
)

if "%CURRENT_VERSION%" == "%LATEST_TAG%" (
    echo already on latest version ^(%LATEST_TAG%^)
) else (
    set choice=n
    for /f "usebackq delims=" %%c in (`powershell.exe "& { (read-host 'Upgrade from %CURRENT_VERSION% to %LATEST_TAG%? [y/N] ' | Out-String).toString() }"`) DO (
        if "%%c" == "y" goto Yes
        if "%%c" == "Y" goto Yes

        echo not upgrading

        Goto End

        :Yes
        echo checking out release %LATEST_TAG%
        mkdir "%cd%\.docker-update"
        git clone --branch release-%LATEST_TAG% git@gitlab.orangehive.de:orangehive/docker-proxy.git "%cd%\.docker-update"
        rmdir /s /q "%cd%\.docker-update\.git"

        echo updating
        (robocopy "%cd%\.docker-update" "%cd%" *.* /s /e > nul 2>&1) ^& (
            rmdir /s /q "%cd%\.docker-update"
            echo %LATEST_TAG%>"%cd%\.version"
            echo .
            echo Please compare your .env file with the .env-dist file to add new or changed entries
            goto End
        )

        :End
        echo done
    )

)

CD "%OLDCWD%"

endlocal
EXIT /B
