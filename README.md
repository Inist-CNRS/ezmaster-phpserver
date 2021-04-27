# ezmaster-phpserver

[![Docker Pulls](https://img.shields.io/docker/pulls/inistcnrs/ezmaster-phpserver.svg)](https://registry.hub.docker.com/u/inistcnrs/ezmaster-phpserver/)

php web server for [ezmaster](https://github.com/Inist-CNRS/ezmaster)


## Changelog

### version 3.2.x

- Support php composer (launch install from with composer.json at each startup)
- add gettext, intl, xsl 

### version 3.0.x

- Upgrade php version to 7.4.12
- replace ssmtp to esmtp
- remove mcrypt (not yet support)

### version 2.0.0

- Add a way to specify the SMTP mail server
