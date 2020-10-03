#!/usr/bin/env bash

# This script will install the service and timer that will be automatically updating your DNS
# record of choice.

function install_service() {
    cat > qazx.service <<EOF
[Unit]
Description=Qazx - Update a DNS record pointing to a dynamic IP adddress
Requires=network.target

[Service]
Type=simple
ExecStart=/usr/bin/docker run --rm --volume $(pwd)/dns:/dns qazx:latest

[Install]
WantedBy=multi-user.target
EOF
    sudo mv qazx.service /etc/systemd/system/qazx.service
    sudo systemctl enable qazx
}

function install_timer() {
    local frequency
    read -p 'Service activation frequency(minutes): ' frequency
    cat > qazx.timer <<EOF
[Unit]
Description=Run qazx every once in a while

[Timer]
OnBootSec=1sec
OnUnitActiveSec=${frequency}min

[Install]
WantedBy=timers.target
EOF
    sudo mv qazx.timer /etc/systemd/system/qazx.timer
    sudo systemctl enable --now qazx.timer
}

function main() {
    printf "%s\n" "Installing qazx.service.."
    install_service

    printf "%s\n" "Installing qazx.timer.."
    install_timer

    printf "%s\n" "Done!"
}

main $@
