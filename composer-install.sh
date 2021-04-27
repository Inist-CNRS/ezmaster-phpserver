#!/bin/sh
set -e

if [ -f "/var/www/html/composer.json" ]; then
	cd /var/www/html/
	php /usr/local/bin/composer install --no-dev
fi
