#!/bin/bash

# Chemin vers Docker Compose
DOCKER_COMPOSE="docker-compose"

# Charger les fichiers d'environnement
ENV_FILES=".env .env.local"
for ENV_FILE in $ENV_FILES; do
  if [ -f "$ENV_FILE" ]; then
    set -a
    . "$ENV_FILE"
    set +a
  fi
done

# Passer tous les arguments à Docker Compose
$DOCKER_COMPOSE "$@"
