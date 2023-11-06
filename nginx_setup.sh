#!/bin/bash

DOMAIN_NAME=$1

install_nginx() {
    # Install nginx package
    echo "Updating packages.."
    sudo apt-get update -y
    echo "Installing NGINX..."
    sudo apt-get install nginx -y
}

# Start and enable NGINX to run on boot
enable_and_start_nginx() {
    echo "Starting NGINX..."
    sudo systemctl start nginx
    echo "Enabling NGINX to start on boot..."
    sudo systemctl enable nginx
}

# Set up a default website configuration
configure_nginx(){
    echo "Configuring NGINX for ${DOMAIN_NAME}..."

    # Remove the default NGINX host that might conflict
    echo "Removing the default NGINX server block..."
    sudo rm -f /etc/nginx/sites-enabled/default

    # Create a directory for the domain if it doesn't exist
    echo "Creating directory for the domain at /var/www/${DOMAIN_NAME}/html..."
    sudo mkdir -p /var/www/${DOMAIN_NAME}/html 

    # Assign ownership of the directory with the $USER environment variable
    sudo chown -R $USER:$USER /var/www/${DOMAIN_NAME}/html

    # Create a sample index.html page
    echo "Creating a sample landing page at /var/www/${DOMAIN_NAME}/html/index.html..."

    echo "<html>
    <head>
        <title>Welcome to ${DOMAIN_NAME}!</title>
    </head>
    <body>
        <h1>Success! The ${DOMAIN_NAME} server block is working!</h1>
    </body>
    </html>" | sudo tee /var/www/${DOMAIN_NAME}/html/index.html

    # Create server block file
    echo "Setting up server configuration file for ${DOMAIN_NAME} (using port 80) at /etc/nginx/sites-available/${DOMAIN_NAME}..."

    echo "server {
    listen 80;
    listen [::]:80;

    root /var/www/${DOMAIN_NAME}/html;
    index index.html;

    server_name ${DOMAIN_NAME} www.${DOMAIN_NAME};

    location / {
        try_files \$uri \$uri/ =404;
    }
    }" | sudo tee /etc/nginx/sites-available/${DOMAIN_NAME}

    # Enable the server block by creating a symbolic link in sites-enabled
    sudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/

    # Check the configuration for syntax errors
    sudo nginx -t

    # Reload NGINX to apply the changes
    sudo systemctl reload nginx
    echo "NGINX has been successfully configured for ${DOMAIN_NAME}."
}

# Setup up the firewall to allow access on ports 22, 80 and 443
setup_firewall() {
    echo "Checking UFW status..."
    # Only enable UFW if it's not already enabled
    if sudo ufw status | grep -q inactive; then
        echo "Enabling UFW..."
        sudo ufw enable
    fi
    
    echo "Securing NGINX with UFW firewall rules for SSH, HTTP, and HTTPS..."
    sudo ufw allow ssh
    sudo ufw allow 'Nginx Full'
    sudo ufw reload
}

main() {
    install_nginx
    enable_and_start_nginx
    configure_nginx
    setup_firewall

    echo "NGINX setup is complete."
}

main