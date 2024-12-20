#!/bin/bash

# Chemin vers Docker Compose
DOCKER_COMPOSE="docker-compose"

# Passer la commande exec à Docker Compose
$DOCKER_COMPOSE exec app "$@"
