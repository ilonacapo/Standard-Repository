#!/bin/bash

echo " Déploiement en cours sur $SERVER_HOST..."

# Vérification des variables d'environnement
echo "Utilisateur SSH : $SERVER_USER"
echo "Hôte SSH : $SERVER_HOST"
echo "Chemin serveur : $SERVER_PATH"

# Exécuter les commandes sur le serveur distant via SSH
ssh -v $SERVER_USER@$SERVER_HOST << EOF
    set -e
    echo "Récupération des dernières modifications depuis Git..."
    cd $SERVER_PATH || exit 1
    git pull origin main || exit 1

    echo " Installation des dépendances PHP..."
    composer install --no-interaction --prefer-dist --optimize-autoloader || exit 1

    echo " Installation des dépendances Node.js..."
    if [ -f "package.json" ]; then
        npm install || exit 1
        echo " Compilation des assets..."
        npm run build || exit 1
    else
        echo " Aucun package.json trouvé, skip npm install."
    fi

    if [ -d "sass" ] || [ -d "scss" ] || find . -name "*.scss" | grep -q .; then
        echo "Compilation des fichiers Sass..."
        if command -v npm &> /dev/null && [ -f "package.json" ]; then
            npm run build || exit 1
        elif command -v sass &> /dev/null; then
            sass src/sass/style.scss public/css/style.css --no-source-map || exit 1
        else
            echo "Aucun compilateur Sass trouvé. Installez soit npm avec un script de build, soit l'outil Sass global."
        fi
    else
        echo "Aucun fichier Sass trouvé, skip compilation."
    fi

    echo "Application des migrations de base de données..."
    php bin/console doctrine:migrations:migrate --no-interaction || exit 1

    echo " Nettoyage du cache..."
    php bin/console cache:clear || exit 1
    php bin/console cache:warmup || exit 1

    echo "Déploiement terminé avec succès !"
EOF
