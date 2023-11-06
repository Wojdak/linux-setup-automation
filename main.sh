#!/bin/bash

DOMAIN_NAME=$2 

 if [ -z "${DOMAIN_NAME}" ]; then 
    echo "Domain name argument is required."
    exit 1
fi

case "$1" in
    start)
        sudo ./nginx_setup.sh "$DOMAIN_NAME"
        ;;
    delete)
     echo "Removing NGINX configuration for ${DOMAIN_NAME}..."
        sudo rm -f /etc/nginx/sites-available/${DOMAIN_NAME}
        sudo rm -f /etc/nginx/sites-enabled/${DOMAIN_NAME}
        sudo rm -rf /var/www/${DOMAIN_NAME}
        sudo systemctl reload nginx
        echo "NGINX configuration for ${DOMAIN_NAME} removed."
        ;;
    *)
        echo "Usage: $0 {start|delete} domain_name"
        exit 1
        ;;
esac
