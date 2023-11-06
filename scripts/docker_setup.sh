#!/bin/bash

# Install packages to allow apt to use a repository over HTTPS
setup_repository(){
    echo "Installing packages to allow apt to use a repository over HTTPS..."
    sudo apt-get update -y
    sudo apt-get install ca-certificates curl gnupg -y
    sudo install -m 0755 -d /etc/apt/keyrings
}

# Setup the GPG key
setup_gpg_key(){
    echo "Adding Docker’s official GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg -y
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
}

# Add Docker repository to apt sources
add_repository(){
    echo "Adding the repository to apt sources..."
    echo \
    "deb [arch='$(dpkg --print-architecture)' signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    '$(. /etc/os-release && echo "$VERSION_CODENAME")' stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
}

# Install the latest versions of Docker packages
install_docker_packages(){
    echo "Installing the latest version of docker packages..."
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
}

# Add current user to Docker group
add_user_to_docker_group(){
    echo "Adding current user to the Docker group..."
    sudo usermod -aG docker "$USER"
}

# Start and enable Docker to run on boot
enable_and_start_docker() {
    echo "Starting Docker..."
    sudo systemctl start docker
    echo "Enabling Docker to start on boot..."
    sudo systemctl enable docker
}

# Testing docker with the default container
test_installation(){
    echo "Running the default docker image to test the installation..."
    sudo docker run hello-world
}

main(){
    setup_repository
    setup_gpg_key
    add_repository
    install_docker_packages
    add_user_to_docker_group
    enable_and_start_docker
    test_installation

    echo "Docker has been installed and started!"
}

main
