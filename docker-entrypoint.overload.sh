#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi
# Fix permissions : avoid different user:group in the exposed directory
chown -R www-data:www-data /var/www/html

exec "$@"
