#!/bin/bash
SYMFONY_VERSION=6.2
PHP_VERSION=8.2
NGINX_VERSION=1.21
MARIADB_VERSION=10.10
NGINX_CONTAINER_NAME=ddd-nginx
PHP_CONTAINER_NAME=ddd-php
DB_CONTAINER_NAME=ddd-db
USER_ID := $(shell id -u)


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
	USER_ID=${USER_ID} MARIADB_VERSION=${MARIADB_VERSION} DB_CONTAINER_NAME=${DB_CONTAINER_NAME} PHP_CONTAINER_NAME=${PHP_CONTAINER_NAME} NGINX_CONTAINER_NAME=${NGINX_CONTAINER_NAME}  NODE_VERSION=${NODE_VERSION} SYMFONY_VERSION=${SYMFONY_VERSION} PHP_VERSION=${PHP_VERSION} NGINX_VERSION=${NGINX_VERSION} docker-compose build --pull

up: ## Start the containers
	USER_ID=${USER_ID} MARIADB_VERSION=${MARIADB_VERSION} DB_CONTAINER_NAME=${DB_CONTAINER_NAME} PHP_CONTAINER_NAME=${PHP_CONTAINER_NAME} NGINX_CONTAINER_NAME=${NGINX_CONTAINER_NAME}  NODE_VERSION=${NODE_VERSION} SYMFONY_VERSION=${SYMFONY_VERSION} PHP_VERSION=${PHP_VERSION} NGINX_VERSION=${NGINX_VERSION} docker-compose up --build --detach

yarn:
	yarn install
	yarn encore dev --watch

stop: ## Stop the containers
	USER_ID=$USER_ID docker-compose stop

down: ## Remove the containers
	USER_ID=$USER_ID docker-compose down --remove-orphans

install-symfony: ## Installs symfony
	docker exec -u appuser -it -e SYMFONY_VERSION=${SYMFONY_VERSION} ${PHP_CONTAINER_NAME} sh /var/www/docker/php/install_symfony.sh
	@make composer-install

ssh: ## ssh's into the PHP container
	@USER_ID=$USER_ID docker exec -it ${PHP_CONTAINER_NAME} bash

restart: ## Restart the containers
	@make stop
	@make up

restart-php: ## Restart the php container
	USER_ID=$USER_ID docker-compose restart ${PHP_CONTAINER_NAME}

composer-install: ## Installs composer dependencies
	USER_ID=$USER_ID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} composer install --no-scripts --no-interaction --optimize-autoloader

cache-clear:
	USER_ID=$USER_ID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} php bin/console c:c

sync-db:
	USER_ID=$USER_ID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} php bin/console doctrine:schema:update --dump-sql --env=dev --force -v

fixtures:
	@make sync-db
	USER_ID=$USER_ID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} php bin/console doctrine:fixtures:load --env=dev -q -v

test:
	USER_ID=$USER_ID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} ./bin/phpunit
