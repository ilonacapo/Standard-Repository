#!/bin/bash

echo " Déploiement en cours sur $SERVER_HOST..."

# Exécuter les commandes sur le serveur distant via SSH
ssh $SERVER_USER@$SERVER_HOST << EOF
    echo "Récupération des dernières modifications depuis Git..."
    cd $SERVER_PATH
    git pull origin main

    echo " Installation des dépendances PHP..."
    composer install --no-interaction --prefer-dist --optimize-autoloader

    echo " Installation des dépendances Node.js..."
    if [ -f "package.json" ]; then
        npm install
        echo " Compilation des assets..."
        npm run build
    else
        echo " Aucun package.json trouvé, skip npm install."
    fi

if [ -d "sass" ] || [ -d "scss" ] || find . -name "*.scss" | grep -q .; then
    echo "Compilation des fichiers Sass..."
    
    if command -v npm &> /dev/null && [ -f "package.json" ]; then
        npm run build
    elif command -v sass &> /dev/null; then
        sass src/sass/style.scss public/css/style.css --no-source-map
    else
        echo "Aucun compilateur Sass trouvé. Installez soit npm avec un script de build, soit l'outil Sass global."
    fi
else
    echo "Aucun fichier Sass trouvé, skip compilation."
fi



    echo "Application des migrations de base de données..."
    php bin/console doctrine:migrations:migrate --no-interaction

    echo " Nettoyage du cache..."
    php bin/console cache:clear
    php bin/console cache:warmup

    echo "Déploiement terminé avec succès !"
EOF
