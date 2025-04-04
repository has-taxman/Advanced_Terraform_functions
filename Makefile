.PHONY: up down restart logs

SHELL := /bin/zsh

docker_compose_file := setup/docker-compose.yml

down:
	docker-compose -f $(docker_compose_file) down

up:
	docker-compose -f $(docker_compose_file) up -d

restart: down up

logs:
	docker-compose -f $(docker_compose_file) logs -f