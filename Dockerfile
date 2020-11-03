FROM php:7.4.12-apache

# APCU
RUN pecl install apcu \
    && pecl install apcu_bc-1.0.3 \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
    && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini

# ldap
RUN apt-get update \
	&& apt-get install -y \
		libldb-dev \
		libldap2-dev --no-install-recommends \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
	&& docker-php-ext-install ldap \
	&& apt-get purge -y \
		libldap2-dev

# gd
RUN apt-get update \
	&& apt-get install -y \
		libfreetype6-dev \
		libpng-dev \
		libjpeg62-turbo-dev \
		libjpeg-dev \
	&& docker-php-ext-configure gd \
	&& docker-php-ext-install -j$(nproc) \
		gd \
	&& apt-get purge -y \
		libfreetype6-dev \
		libpng-dev \
		libjpeg62-turbo-dev \
		libjpeg-dev

# imagick (pecl)
RUN apt-get update \
	&& apt-get install -y \
		libmagickwand-dev --no-install-recommends \
		ghostscript --no-install-recommends \
	&& pecl install \
		imagick \
	&& docker-php-ext-enable \
		imagick \
	&& apt-get purge -y \
		libmagickwand-dev

# xml*
RUN apt-get update \
	&& apt-get install -y \
		libxml2-dev --no-install-recommends \
	&& CFLAGS="-I/usr/src/php" docker-php-ext-install xml xmlreader simplexml \
	&& apt-get purge -y \
		libxml2-dev

# zip*
RUN apt-get update \
	&& apt-get install -y \
		libzip-dev \
		zlib1g-dev \
	&& docker-php-ext-install zip \
	&& apt-get purge -y \
		libzip-dev \
		zlib1g-dev

# libsodium
RUN apt-get update \
	&& apt-get install -y \
		libsodium-dev \
	&& pecl install libsodium \
	&& apt-get purge -y \
		libsodium-dev

# mbstring
RUN apt-get update \
	&& apt-get install -y \
		libmcrypt-dev \
		libonig-dev \
	&& docker-php-ext-install mbstring \
	&& apt-get purge -y \
		libmcrypt-dev \
		libonig-dev

# Divers
RUN apt-get install -y \
		graphviz \
		esmtp \
	&& docker-php-ext-install -j$(nproc) \
		mysqli \
		exif \
	&& rm -r /var/lib/apt/lists/*

# Apache : rewrite
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
