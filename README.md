# Linux Setup Automation Scripts

This repository contains a set of scripts designed to automate the setup and configuration of different services on a Linux system. The following services can be managed:

- NGINX: Installation and domain setup, including server block configuration and removal.
- Docker: Installation and removal of Docker along with its dependencies.
- PostgreSQL: Installation of PostgreSQL and creation of user databases.

## Prerequisites

Before using these scripts, ensure you have `sudo` privileges on the system where the scripts will be executed.

## Installation

Clone the repository to your local machine using the following command:

```bash
git clone https://github.com/Wojdak/linux-setup-automation.git
cd linux-setup-automation
```
Change the permission of the scripts to make them executable:
```bash
chmod +x ./scripts/*.sh
```
## Usage
The scripts are managed via a main script called main.sh. To use the scripts, run main.sh with the corresponding arguments.

A full list of commands can be displayed with:
```bash
./main.sh
```

Available Commands:
```
install-nginx [domain_name] - Set up a domain and start NGINX for that domain.
delete-nginx [domain_name] - Delete the NGINX configuration for a domain.

install-docker - Install Docker and its dependencies.
remove-docker - Remove Docker and its data.

install-postgres - Install PostgreSQL.
create-postgres-db [user] [password] [database] - Create a PostgreSQL user and database.
```

Example usage:
```bash
./main.sh install-nginx yourdomain.com (after installation, the domain will be available on port 80 by default)
./main.sh install-docker
./main.sh create-postgres-db username password dbname
```
