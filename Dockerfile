FROM php:5.6-apache

MAINTAINER Bruno Emanuel <bemanuel.pe@gmail.com>

RUN apt-get update && \ 
	apt-get install -y git php-pear php5-curl php5-gd \
        php5-mysql php5-json php5-gmp php5-mcrypt php5-ldap \
        libgmp-dev libmcrypt-dev libldap2-dev curl \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev && \
	rm -rf /var/lib/apt/lists/*

# Configure apache and required PHP modules 
RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
	docker-php-ext-install mysqli && \
	docker-php-ext-install pdo_mysql && \
	docker-php-ext-install gettext && \ 
        docker-php-ext-install pcntl && \ 
	ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h && \
	docker-php-ext-configure gmp --with-gmp=/usr/include/x86_64-linux-gnu && \
	docker-php-ext-install gmp && \
	docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
        docker-php-ext-install ldap && \
        docker-php-ext-install mcrypt && \
        docker-php-ext-install -j$(nproc) iconv mcrypt && \
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
        docker-php-ext-install -j$(nproc) gd && \
	echo ". /etc/environment" >> /etc/apache2/envvars && \
	a2enmod rewrite


RUN git clone https://github.com/ChurchCRM/CRM.git /churchcrm && mv /churchcrm/src /app

RUN rm -rf /var/www/html && ln -s /app /var/www/html

EXPOSE 80 443
