#!/usr/bin/env bash

# This script will import your Cloudflare zone into the local Terraform state.
# Use this script if your zone already exists and does not need to be recreated.
# Warning: you must have ran the configure script before running this!

function main() {
    docker run \
        --env QAZX_CMD=import_zone \
        --rm \
        --volume $(pwd)/dns:/dns \
        qazx:latest
}

main $@
