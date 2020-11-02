FROM php:7.4.12-apache

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        esmtp \
		libldap2-dev \
    && docker-php-ext-install -j$(nproc) mysqli iconv \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
	&& docker-php-ext-install ldap \
    && docker-php-ext-install -j$(nproc) gd

# Install APCu and APC backward compatibility
RUN pecl install apcu \
    && pecl install apcu_bc-1.0.3 \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
    && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini

RUN a2enmod rewrite

COPY php.ini /usr/local/etc/php/
COPY www/ /var/www/html/

# ezmasterization 
# see https://github.com/Inist-CNRS/ezmaster
RUN echo '{ \
  "httpPort": 80, \
  "configPath": "/usr/local/etc/php/php.ini", \
  "configType": "text", \
  "dataPath": "/var/www/html/" \
}' > /etc/ezmaster.json

COPY docker-entrypoint.overload.sh /usr/local/bin/
ENTRYPOINT [ "docker-entrypoint.overload.sh" ]
CMD ["apache2-foreground"]
