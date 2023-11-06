#!/bin/bash

# Install postgres packages
install_postgres() {
    echo "Installing PostgreSQL..."
    sudo apt-get update -y
    sudo apt-get install -y postgresql postgresql-contrib
}

# Start and enable postgres to run on boot
enable_and_start_postgres() {
    echo "Starting PostgreSQL service..."
    sudo systemctl start postgresql
    echo "Enabling PostgreSQL service to start on boot..."
    sudo systemctl enable postgresql
}

# Create a new user and a database
create_user_and_db(){
    local db_user=$1 
    local db_pass=$2
    local db_name=$3 

    # Commands to create a new user and a database
    echo "Creating new user and a database..."
    sudo -u postgres psql -c "CREATE USER $db_user WITH ENCRYPTED PASSWORD '$db_pass';"
    sudo -u postgres createdb -O $db_user $db_name
    echo "Creation complete."
}

# The main function to control the flow of the script
main(){
    local operation=$1
    shift # Remove the first argument and use the rest for the operation function

    case "$operation" in
        install)
            install_postgres
            enable_and_start_postgres
            ;;
        create)
            create_user_and_db "$@"
            ;;
        *)
            echo "Invalid operation: $operation"
            echo "Usage: $0 {install|create} [arguments...]"
            exit 1
            ;;
    esac

}

# Call main with all passed arguments
main "$@"
