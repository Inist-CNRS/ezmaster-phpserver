#!/bin/sh
set -e

cd /var/www/html/
php /usr/local/bin/composer install --no-dev
