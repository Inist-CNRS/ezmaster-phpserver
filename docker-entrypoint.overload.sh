#!/bin/sh
set -e

# adjust mail server parmeters from php.ini values
SMTP_HOST=$(php -r "echo ini_get('SMTP');")
SMTP_PORT=$(php -r "echo ini_get('smtp_port');")
sed -i "s/[#]*hostname=.*/hostname=$SMTP_HOST:$SMTP_PORT/g" /etc/esmtprc

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

if [ -f "/var/www/html/composer.json" ]; then
	/usr/local/bin/composer-install.sh &
fi

# Fix permissions : avoid different user:group in the exposed directory
chown -R www-data:daemon /var/www/html
# to allow webdav server to modify all files
chmod -R 770 /var/www/html
# to allow daemon to use temp directory
chmod 1777 /tmp

exec "$@"
