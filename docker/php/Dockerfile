ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

ARG UID
RUN adduser -u $UID --disabled-password --gecos "" appuser
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
RUN docker-php-ext-install pdo_mysql exif pcntl
RUN docker-php-ext-configure gd
RUN docker-php-ext-install gd
RUN docker-php-ext-install opcache
RUN docker-php-ext-configure intl

#COMPOSER
RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer

###XDEBUG
RUN pecl install xdebug && docker-php-ext-enable xdebug

#SYMFONY CLI
RUN echo "export COLUMNS=300" >> /home/appuser/.bashrc
RUN echo "alias sf='/usr/local/bin/php /var/www/bin/console'" >> /home/appuser/.bashrc
RUN curl -sS https://get.symfony.com/cli/installer | bash && mv /root/.symfony/bin/symfony /usr/local/bin/symfony
#RUN symfony check:requirements

#INSTALL SYMFONY
RUN mkdir -p /var/www

USER appuser

WORKDIR /var/www
