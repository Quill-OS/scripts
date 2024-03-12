#!/bin/bash
function icho() {
    local message="$1"
    if [ "$INKBOX_DEBUG_MESSAGES" = "1" ]; then
        echo $message
    fi
}

function install_debian_packages() {
    echo "Installing needed packages with apt-get..."
    sudo apt-get install git openssh-server sshpass squashfs-tools
}

function install_arch_packages() {
    echo "Installing needed packages with pacman..."
    sudo pacman -S git openssh sshpass squashfs-tools
}

function install_packages() {
    cmd=$1
    if command -v pacman &> /dev/null; then
      install_arch_packages
    elif command -v apt-get &> /dev/null; then
      install_debian_packages
    else
      echo "Unsupported package manager. Please install $cmd manually."
      INKBOX_STOP=1
      return
    fi
}

NEEDED_COMMANDS=("ssh" "git" "sshpass" "mksquashfs")

function check_for_tools() {
    icho "Checking for tools"
    for cmd in "${NEEDED_COMMANDS[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            packages=""
            for item in "${NEEDED_COMMANDS[@]}"; do
                packages+=" $item"
            done
            echo "Installing commands: $packages"
            install_packages "$cmd"
            break
        fi
    done
}
check_for_tools