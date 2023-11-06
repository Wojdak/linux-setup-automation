#!/bin/bash

# Function to install NGINX
install_nginx() {
    local domain_name=$1
    sudo ./scripts/nginx_setup.sh "$domain_name"
}

# Function to delete NGINX configurations
delete_nginx() {
    local domain_name=$1
    echo "Removing NGINX configuration for ${domain_name}..."
    sudo rm -f /etc/nginx/sites-available/"$domain_name"
    sudo rm -f /etc/nginx/sites-enabled/"$domain_name"
    sudo rm -rf /var/www/"$domain_name"
    sudo systemctl reload nginx
    echo "NGINX configuration for ${domain_name} removed."
}

# Function to install Docker
install_docker() {
    sudo ./scripts/docker_setup.sh
}

# Function to remove Docker
delete_docker() {
    echo "Removing Docker..."
    sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
    echo "Docker has been removed."
}

# Function to install PostgreSQL
install_postgres() {
    echo "Installing PostgreSQL..."
    sudo ./scripts/postgres_setup.sh install
}

# Function to create PostgreSQL database
create_postgres_db() {
    local db_user=$1
    local db_pass=$2
    local db_name=$3
    sudo ./scripts/postgres_setup.sh create "$db_user" "$db_pass" "$db_name"
}


# Usage information
print_usage() {
    echo -e "Usage: $0 options\n"
    echo -e "Where options include:\n"
    echo -e "install-nginx [domain_name] - Set up a domain and start NGINX for that domain"
    echo -e "delete-nginx [domain_name] - Delete the NGINX configuration for a domain"
    echo -e "install-docker - Install Docker and its dependencies"
    echo -e "delete-docker - Remove Docker and its data"
    echo -e "install-postgres - Install PostgreSQL"
    echo -e "create-postgres-db [user] [password] [database] - Create a PostgreSQL user and database"
}

# Make sure that the script is run with at least one argument
if [ $# -lt 1 ]; then
    print_usage
    exit 1
fi

# Process the arguments
case "$1" in
    install-nginx)
        if [ -z "$2" ]; then
            echo "Domain name argument is required for NGINX setup."
            exit 1
        fi
        install_nginx "$2"
        ;;
    delete-nginx)
         if [ -z "$2" ]; then
            echo "Domain name argument is required for NGINX setup."
            exit 1
        fi
        delete_nginx "$2"
        ;;
    install-docker)
        install_docker
        ;;
    delete-docker)
        delete_docker
        ;;
    install-postgres)
        install_postgres
        ;;
    create-postgres-db)
        if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
            echo "Username, password, and database name arguments are required for PostgreSQL setup."
            exit 1
        fi
        create_postgres_db "$2" "$3" "$4"
        ;;
    *)
        print_usage
        exit 1
        ;;
esac
