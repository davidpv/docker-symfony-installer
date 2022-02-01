#!/bin/bash
SYMFONY_VERSION=6.0
PHP_VERSION=8.1
NGINX_VERSION=1.21
NGINX_CONTAINER_NAME=sf6encore-nginx
PHP_CONTAINER_NAME=sf6encore-php
UID := $(shell id -u)


help: ## Show this help message
	@echo
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

.SILENT: run

init:
	@make build
	@make up

build:
	UID=${UID} PHP_CONTAINER_NAME=${PHP_CONTAINER_NAME} NGINX_CONTAINER_NAME=${NGINX_CONTAINER_NAME}  NODE_VERSION=${NODE_VERSION} SYMFONY_VERSION=${SYMFONY_VERSION} PHP_VERSION=${PHP_VERSION} NGINX_VERSION=${NGINX_VERSION} docker-compose build --pull --force

up: ## Start the containers
	UID=${UID} PHP_CONTAINER_NAME=${PHP_CONTAINER_NAME} NGINX_CONTAINER_NAME=${NGINX_CONTAINER_NAME}  NODE_VERSION=${NODE_VERSION} SYMFONY_VERSION=${SYMFONY_VERSION} PHP_VERSION=${PHP_VERSION} NGINX_VERSION=${NGINX_VERSION} docker-compose up --detach

down: ## Stop the containers
	UID=$UID docker-compose down --remove-orphans

install-symfony: ## Installs symfony
	docker exec -u appuser -it -e SYMFONY_VERSION=${SYMFONY_VERSION} ${PHP_CONTAINER_NAME} sh /var/www/docker/php/install_symfony.sh
	@make composer-install
#	yarn install
#	yarn encore dev --watch

ssh: ## ssh's into the PHP container
	UID=$UID docker exec -it ${PHP_CONTAINER_NAME} bash

restart: ## Restart the containers
	UID=${UID} PHP_CONTAINER_NAME=${PHP_CONTAINER_NAME} NGINX_CONTAINER_NAME=${NGINX_CONTAINER_NAME}  NODE_VERSION=${NODE_VERSION} SYMFONY_VERSION=${SYMFONY_VERSION} PHP_VERSION=${PHP_VERSION} NGINX_VERSION=${NGINX_VERSION} $(MAKE) down && $(MAKE) up

restart-php: ## Restart the php container
	UID=$UID docker-compose restart ${PHP_CONTAINER_NAME}

composer-install: ## Installs composer dependencies
	UID=$UID docker exec --user ${UID} -it ${PHP_CONTAINER_NAME} composer install --no-scripts --no-interaction --optimize-autoloader
