#!/bin/sh
set -e

# adjust mail server parmeters from php.ini values
sed -i "s/#FromLineOverride=YES/FromLineOverride=YES/g" /etc/ssmtp/ssmtp.conf
SMTP_HOST=$(php -r "echo ini_get('SMTP');")
SMTP_PORT=$(php -r "echo ini_get('smtp_port');")
sed -i "s/^mailhub=.*$/mailhub=$SMTP_HOST:$SMTP_PORT/g" /etc/ssmtp/ssmtp.conf

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi
# Fix permissions : avoid different user:group in the exposed directory
chown -R www-data:daemon /var/www/html
# to allow webdav server to modify all files
chmod -R 770 /var/www/html

exec "$@"
