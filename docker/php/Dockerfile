ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

ARG USER_ID
RUN adduser -u $USER_ID --disabled-password --gecos "" appuser
RUN mkdir /home/appuser/.ssh
RUN chown -R appuser:appuser /home/appuser/
RUN echo "StrictHostKeyChecking no" >> /home/appuser/.ssh/config

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libicu-dev

#EXTENSIONS
# https://github.com/mlocati/docker-php-extension-installer
RUN curl -sSLf -o /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
		&& chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions gd opcache intl pdo_mysql exif pcntl @composer

###XDEBUG
RUN install-php-extensions xdebug
#RUN pecl install xdebug && docker-php-ext-enable xdebug

#SYMFONY CLI
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash
RUN apt install symfony-cli

#INSTALL SYMFONY
RUN mkdir -p /var/www

USER appuser

WORKDIR /var/www
