# Executables
DOCKER_COMP = docker compose

# Variables
SERVICE ?= $(shell bash -c 'read -p "Service: " service; echo $$service')

# Misc
.DEFAULT_GOAL = help
.PHONY        : help build up down reset recreate logs sh

## —— Docker ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

reset: ## Stops the docker hub and deletes all its data including all images
	@$(DOCKER_COMP) down --remove-orphans --volumes --rmi all

recreate: ## Recreate a service
	@$(DOCKER_COMP) up --detach --force-recreate --no-deps $(SERVICE)

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the service container
	@$(DOCKER_COMP) exec $(SERVICE) sh




