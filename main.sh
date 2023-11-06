#!/bin/bash

DOMAIN_NAME=$2 

case "$1" in
    install-nginx)
        if [ -z "${DOMAIN_NAME}" ]; then 
            echo "Domain name argument is required for NGINX setup."
            exit 1
        fi
        sudo ./nginx_setup.sh "$DOMAIN_NAME"
        ;;
    delete-nginx)
        if [ -z "${DOMAIN_NAME}" ]; then 
            echo "Domain name argument is required for NGINX removal."
            exit 1
        fi
        echo "Removing NGINX configuration for ${DOMAIN_NAME}..."
        sudo rm -f /etc/nginx/sites-available/${DOMAIN_NAME}
        sudo rm -f /etc/nginx/sites-enabled/${DOMAIN_NAME}
        sudo rm -rf /var/www/${DOMAIN_NAME}
        sudo systemctl reload nginx
        echo "NGINX configuration for ${DOMAIN_NAME} removed."
        ;;
    install-docker)
        sudo ./docker_setup.sh
        ;;
    remove-docker)
        echo "Removing Docker..."
        sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
        sudo rm -rf /var/lib/docker
        sudo rm -rf /var/lib/containerd
        echo "Docker has been removed."
        ;;
    *)
        echo -e "Usage: $0 options\n"
        echo -e "Where options include:\n"
        echo -e "install-nginx [domain_name] - Set up a domain and start NGINX for that domain\n"
        echo -e "delete-nginx [domain_name] - Delete the NGINX configuration for a domain\n"
        echo -e "install-docker - Install Docker and its dependencies\n"
        echo -e "remove-docker - Remove Docker and its data\n"

        exit 1
        ;;
esac
