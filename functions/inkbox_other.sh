#!/bin/bash
function icho() {
    local message="$1"
    if [ "$INKBOX_DEBUG_MESSAGES" = "1" ]; then
        echo $message
    fi
}

RED='\033[0;31m'
NC='\033[0m' # No Color
function ero() {
    local message="$1"
    echo -e "${RED}${message}${NC}"
}

function install_debian_packages() {
    echo "Installing needed packages with apt-get..."
    sudo apt-get install git openssh-server sshpass squashfs-tools sshfs expect pkg-config libssl-dev
}

function install_arch_packages() {
    echo "Installing needed packages with pacman..."
    sudo pacman -S git openssh sshpass squashfs-tools sshfs expect pkgconf openssl
}

function install_packages() {
    cmd=$1
    if command -v pacman &> /dev/null; then
      install_arch_packages
    elif command -v apt-get &> /dev/null; then
      install_debian_packages
    else
      ero "Unsupported package manager. Please install $cmd manually."
      INKBOX_STOP=1
      return
    fi
}

NEEDED_COMMANDS=("ssh" "git" "sshpass" "mksquashfs" "sshfs" "expect")
INSTALL_COMMANDS=("cargo")

NEEDED_LIBS=("libssl")

function install_libs() {
    packages=""
    for item in "${NEEDED_LIBS[@]}"; do
        packages+=" $item"
    done
    echo "Checking for libs:$packages"
    install_libs
}

function check_for_libs() {
    for lib in "${NEEDED_LIBS[@]}"; do
        pkg-config --exists $lib || install_libs
    done
}
check_for_libs

function check_for_tools() {
    icho "Checking for tools"
    for cmd in "${NEEDED_COMMANDS[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            packages=""
            for item in "${NEEDED_COMMANDS[@]}"; do
                packages+=" $item"
            done
            echo "Installing commands:$packages"
            install_packages "$cmd"
            break
        fi
    done

    . "$HOME/.cargo/env"
    rustup default stable 1>/dev/null 2>/dev/null
    for cmd in "${INSTALL_COMMANDS[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            packages=""
            for item in "${INSTALL_COMMANDS[@]}"; do
                packages+=" $item"
            done
            ero "Install these commands by yourself:$packages"
            INKBOX_STOP=1
        fi
    done
}
check_for_tools