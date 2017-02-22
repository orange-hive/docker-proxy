# Anleitung

## Installation

* Das aktulle Release unter Tags herunterladen (**nicht auschecken**)
* Die Datei .env-dist nach .env kopieren und anpassen (**mindestens die `BASE_DOMAIN`**)
* Die Datei docker-data/config-dist nach docker-data/config kopieren und anpassen wen nötig

Folgende Einstellungsmöglichkeiten gibt es:

* `PROXY_PORT`<br />
    Der Port für den Proxy unter dem Web-Container erreichbar sind (nur um korrekt Links zu bauen)

* `GRAYLOG_ADMIN_PASSWORD`<br />
    Das Passwort für die Graylog-Oberfläche

* `BASE_DOMAIN`<br />
    Die Domain for docker-ui und graylog


## Betrieb

Alle Kommandos befinden sich im Verzeichnis `bin`.

Folgende Kommandos gibt es:

* `./control.cmd start` (OSX) / `control.cmd start` (Win)<br />
    Zum starten der Services.
 
* `./control.cmd stop` (OSX) / `control.cmd stop` (Win)<br />
    Zum Beenden der Services.
  
* `./control.cmd logs` (OSX) / `control.cmd logs` (Win)<br />
    Zum Anzeigen der Logs, wenn mit -d gestartet
  
* `./control.cmd update-docker-proxy` (OSX) / `control.cmd update-docker-proxy` (Win)<br />
    Zum updaten dieses Systems
  