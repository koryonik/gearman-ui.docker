FROM php:5.6-apache

MAINTAINER Damien Roch, damien.roch@gmail.com

# Enable apache rewrite module
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/

# Install Composer
RUN mkdir -p /usr/local/bin && php -r "readfile('https://getcomposer.org/installer');" | php \
    && mv composer.phar /usr/local/bin/composer

# Copy PHP configuration file
COPY build/php.ini /usr/local/etc/php/

# Install utils
RUN apt-get update && apt-get install -y unzip curl git

# Install Gearman UI from source on github
RUN curl -L https://github.com/gaspaio/gearmanui/archive/master.zip -o /tmp/gearmanui.zip \
	&& unzip -uo /tmp/gearmanui.zip -d /tmp/gearmanui \
	&& mv /tmp/gearmanui/gearmanui-master /gearmanui \
	&& rm -Rf /tmp/gearmanui.zip /tmp/gearmanui \
	&& rm -Rf /var/www/html \
	&& ln -s /gearmanui/web /var/www/html

# Copy default Gearman UI configuration file
COPY build/gearmanui.yml /gearmanui/app/config/

# Install Gearman UI PHP Dependencies with Composer
WORKDIR /gearmanui
RUN composer install

