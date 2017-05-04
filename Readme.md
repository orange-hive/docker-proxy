# Instructions

## Installation

* Download the new release tag (**do not checkout master branch**)
* Copy .env-dist to .env and configure it
* Copy docker-data/config-dist to docker-data/config and configure it if necessary

Configuration in .env:

* `PROXY_PORT`<br />
    Public port for nginx container

* `PROXY_PORT_SSL`<br />
    Public ssl port for nginx container

* `LETSENCRYPT`<br />
    Use Letsencrypt for ssl certificates (nginx ports have to be public accessible)

* `ELK_VERSION`<br />
    ELK Version to use (only 5.2.2 tested)

* `ELASTIC_PASSWORD`<br />
    Password for kibana and docker-ui webinterfaces (user: elastic)

* `AUTOPULL`<br />
    Update container images automatically on startup

* `LICENSE_EMAIL`<br />
    The email that gets expiring license information

* `LICENSE_WARN_DAYS`<br />
    Send expiring email if license is about to expire in LICENSE_WARN_DAYS days 

* `PRODUCTION`<br />
    Use production configuration

* `BASE_DOMAIN`<br />
    base domain for kibana and docker-ui (webinterfaces: kibana.$BASE_DOMAIN and docker-ui.$BASE_DOMAIN)


## Usage

There are the following commands:

* `./control.cmd start` (Unix) / `control.cmd start` (Win)<br />
    start services
 
* `./control.cmd stop` (Unix) / `control.cmd stop` (Win)<br />
    stop services.

* `./control.cmd pull` (Unix) / `control.cmd pull` (Win)<br />
    download new container images if available.

* `./control.cmd logs` (Unix) / `control.cmd logs` (Win)<br />
    show logs<br />
    default is elk-logstash, but you can see logs of the folloging container:
    nginx, elk-elasticsearch, elk-logstash, elk-kibana
  
* `./control.cmd update-docker-proxy` (Unix) / `control.cmd update-docker-proxy` (Win)<br />
    update to new docker-proxy-template
  
* `./control.cmd update-license` (Unix) / `control.cmd update-license` (Win)<br />
    activate new license located under docker-data/config/container/elasticsearch/license.json
