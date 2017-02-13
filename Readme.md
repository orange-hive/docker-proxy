# Anleitung

## Installation

* Das aktulle Release unter Tags herunterladen (**nicht auschecken**)
* Die Datei .env-dist nach .env kopieren und anpassen (**mindestens die `BASE_DOMAIN`**)

Folgende Einstellungsmöglichkeiten gibt es:

* `PROXY_PORT`<br />
    Der Port für den Proxy unter dem Web-Container erreichbar sind (nur um korrekt Links zu bauen)

* `GRAYLOG_ADMIN_PASSWORD`<br />
    Das Passwort für die Graylog-Oberfläche

## Betrieb

Alle Kommandos befinden sich im Verzeichnis `bin`.

Folgende Kommandos gibt es:

* `bin/start.cmd` (OSX) / `bin\start.cmd` (Win)<br />
    Zum starten der Services.
 
* `bin/stop.cmd` (OSX) / `bin\stop.cmd` (Win)<br />
    Zum Beenden der Services.
  