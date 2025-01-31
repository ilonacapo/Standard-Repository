
# Template de Projet Web 

Ce repository contient une structure standard pour démarrer un projet web et est conçu pour être modifié et adapté à chaque projet.

---

## Structure des Fichiers

- **Dockerfile** : Configure l'environnement PHP-FPM pour le projet.
- **docker-compose.yml** : Configure les services Docker (application, base de données, Nginx).
- **php.ini** : Configuration PHP personnalisée.
- **nginx.conf** : Configuration Nginx pour servir l'application Symfony.
- **Makefile** : Simplifie les commandes courantes (build, push, etc.).

---

## **Comment utiliser ce template**

### 1. Configurer le Projet

1. **Dockerfile** :
   - Ajustez la version de PHP ou les extensions nécessaires pour votre projet.
   - Exemple :
     ```dockerfile
     FROM php:8.2-fpm
     ```

2. **docker-compose.yml** :
   - Modifiez les paramètres de la base de données :
     ```yaml
     environment:
       MYSQL_ROOT_PASSWORD: rootpassword
       MYSQL_DATABASE: nom_de_votre_base
       MYSQL_USER: utilisateur
       MYSQL_PASSWORD: mot_de_passe
     ```

3. **php.ini** (optionnel) :
   - Ajustez les paramètres PHP (taille des uploads, mémoire, etc.).

4. **nginx.conf** :
   - Changez `root` pour pointer vers le répertoire `public` de votre projet Symfony :
     ```nginx
5. **Configurez vos bvariables d'environnement**
    - A savoir, set les variables dans le .env.example avec les bonnes valeurs
    SSH_DEPLOY_USER=deployuser
    SSH_DEPLOY_HOST=192.168.1.1
    SSH_KEY_PATH=~/.ssh/id_rsa_deploy
    DEPLOY_DIR=/var/www
    SERVER_USER="exemple"
    SERVER_HOST="exemple"
    SERVER_PATH="exemples"