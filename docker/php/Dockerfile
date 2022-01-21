ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

ARG UID
RUN adduser -u $UID --disabled-password --gecos "" appuser
RUN mkdir /home/appuser/.ssh
RUN chown -R appuser:appuser /home/appuser/
RUN echo "StrictHostKeyChecking no" >> /home/appuser/.ssh/config

RUN apt-get update
#RUN apt-get install -y git zip libzip-dev libicu-dev openssl vim
RUN apt-get install -y git libzip-dev
#RUN docker-php-ext-install zip intl pdo_mysql
RUN docker-php-ext-install zip

#COMPOSER
RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer

###XDEBUG
RUN pecl install xdebug && docker-php-ext-enable xdebug

#SYMFONY CLI
RUN echo "export COLUMNS=300" >> /home/appuser/.bashrc
RUN echo "alias sf='/usr/local/bin/php /appdata/www/bin/console'" >> /home/appuser/.bashrc
RUN curl -sS https://get.symfony.com/cli/installer | bash && mv /root/.symfony/bin/symfony /usr/local/bin/symfony
#RUN symfony check:requirements

#INSTALL SYMFONY
RUN mkdir -p /var/www

USER appuser

WORKDIR /var/www
