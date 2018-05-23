#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi
# Fix permissions : avoid different user:group in the exposed directory
chown -R www-data:daemon /var/www/html
# to allow webdav server to modify all files
chmod -R 770 /var/www/html

exec "$@"
