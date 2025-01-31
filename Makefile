# variables
WALLET_DIR = .wallet
SSH_KEY = $(WALLET_DIR)/id_rsa

# vérifier si docker compose est installé
check-docker-compose:
	@if ! [ -x "$$(command -v docker)" ]; then \
		echo "Docker Compose n'est pas installé. Installation en cours..."; \
		$(MAKE) install-docker-compose; \
	else \
		echo "Docker Compose est déjà installé."; \
	fi

#installer docker compose (Linux/WSL)
install-docker-compose:
	@if [ "$(shell uname -s)" = "Linux" ]; then \
		sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/local/bin/docker-compose && \
		sudo chmod +x /usr/local/bin/docker-compose && \
		echo "Docker Compose installé avec succès."; \
	else \
		echo "Installez manuellement Docker Compose sur votre système Windows ou via Docker Desktop."; \
	fi

create-wallet:
	@if [ ! -d "$(WALLET_DIR)" ]; then \
		mkdir -p $(WALLET_DIR); \
		echo "Dossier .wallet créé."; \
	else \
		echo "Le dossier .wallet existe déjà."; \
	fi
	@if [ ! -f "$(SSH_KEY)" ]; then \
		ssh-keygen -t rsa -b 4096 -f $(SSH_KEY) -N "" -q; \
		echo "Clé SSH créée dans $(SSH_KEY)."; \
	else \
		echo "La clé SSH existe déjà dans $(SSH_KEY)."; \
	fi

generate-ssh-key:
	mkdir -p ~/.ssh
	ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_deploy -N "" -C "deploy_key"
	@echo "Clé SSH générée à ~/.ssh/id_rsa_deploy"

setup-env:
	cp .env.example .env.local
	@echo "Modifiez .env.local avec vos configurations."

deploy:
	./scripts/deploy.sh $(ENV) $(DOMAIN)

test:
	@echo "test"

compile:
	php bin/console asset-map:compile