#!/usr/bin/env bash

# This script will configure the required Terraform variables and build the Docker image.

# Fill the main.tfvars file required by Terraform to automatically update your DNS record.
function fill_main_tfvars() {
    local cloudflare_api_token
    read -sp 'Your Cloudflare API key(will not be displayed): ' cloudflare_api_token
    printf "\n"
    local cloudflare_zone_main
    read -p 'Your Cloudflare zone name: ' cloudflare_zone_main
    local cloudflare_record_main
    read -p 'Your Cloudflare record name: ' cloudflare_record_main
    printf "\n"

    cat > dns/main.auto.tfvars <<EOF
# Template for the variables that need to be set manually.

# Cloudflare API token.
cloudflare_api_token   = "${cloudflare_api_token}"
# Cloudflare zone of choice.
cloudflare_zone_main   = "${cloudflare_zone_main}"
# The name of the DNS record that will be created and updated.
cloudflare_record_main = "${cloudflare_record_main}"
EOF
}

# Build the Docker image for qazx.
function build_docker_image() {
    local tf_version
    read -p 'Terraform version: ' tf_version
    local tf_arch
    read -p 'Terraform arch: ' tf_arch
    printf "\n"

    sudo docker build \
        --build-arg tf_version="${tf_version}" \
        --build-arg tf_arch="${tf_arch}" \
        --tag qazx:latest \
        .
}

function main() {
    printf "%s\n\n" "Filling the main.auto.tfvars file. You will be asked a few questions."
    fill_main_tfvars

    printf "%s\n" "Building the docker image for qazx."
    printf "%s\n\n" "Please check https://github.com/hashicorp/terraform/releases for the version and architecture of Terraform you would like to use."
    build_docker_image
}

main $@
