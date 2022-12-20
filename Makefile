#!/bin/bash
SYMFONY_VERSION=6.0
PHP_VERSION=8.1
NGINX_VERSION=1.21
MARIADB_VERSION=10.6
NGINX_CONTAINER_NAME=ddd-nginx
PHP_CONTAINER_NAME=ddd-php
DB_CONTAINER_NAME=ddd-db
UID := $(shell id -u)


help: ## Show this help message
	@echo
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

.SILENT: run

init:
	@make restart

build:
	UID=${UID} MARIADB_VERSION=${MARIADB_VERSION} DB_CONTAINER_NAME=${DB_CONTAINER_NAME} PHP_CONTAINER_NAME=${PHP_CONTAINER_NAME} NGINX_CONTAINER_NAME=${NGINX_CONTAINER_NAME}  NODE_VERSION=${NODE_VERSION} SYMFONY_VERSION=${SYMFONY_VERSION} PHP_VERSION=${PHP_VERSION} NGINX_VERSION=${NGINX_VERSION} docker-compose build --pull

up: ## Start the containers
	UID=${UID} MARIADB_VERSION=${MARIADB_VERSION} DB_CONTAINER_NAME=${DB_CONTAINER_NAME} PHP_CONTAINER_NAME=${PHP_CONTAINER_NAME} NGINX_CONTAINER_NAME=${NGINX_CONTAINER_NAME}  NODE_VERSION=${NODE_VERSION} SYMFONY_VERSION=${SYMFONY_VERSION} PHP_VERSION=${PHP_VERSION} NGINX_VERSION=${NGINX_VERSION} docker-compose up --detach

yarn:
	yarn install
	yarn encore dev --watch

stop: ## Stop the containers
	UID=$UID docker-compose stop

down: ## Remove the containers
	UID=$UID docker-compose down --remove-orphans

install-symfony: ## Installs symfony
	docker exec -u appuser -it -e SYMFONY_VERSION=${SYMFONY_VERSION} ${PHP_CONTAINER_NAME} sh /var/www/docker/php/install_symfony.sh
	@make composer-install

ssh: ## ssh's into the PHP container
	UID=$UID docker exec -it ${PHP_CONTAINER_NAME} bash

restart: ## Restart the containers
	@make stop
	@make up

restart-php: ## Restart the php container
	UID=$UID docker-compose restart ${PHP_CONTAINER_NAME}

composer-install: ## Installs composer dependencies
	UID=$UID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} composer install --no-scripts --no-interaction --optimize-autoloader

cache-clear:
	UID=$UID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} php bin/console c:c

sync-db:
	UID=$UID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} php bin/console doctrine:schema:update --dump-sql --env=dev --force -v

fixtures:
	@make sync-db
	UID=$UID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} php bin/console doctrine:fixtures:load --env=dev -q -v

test:
	UID=$UID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} ./bin/phpunit
