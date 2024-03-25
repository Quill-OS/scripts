#!/bin/bash
function icho() {
    local message="$1"
    if [ "$QOS_DEBUG_MESSAGES" = "1" ]; then
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
      QOS_STOP=1
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

    . "$HOME/.cargo/env" 1>/dev/null 2>/dev/null
    rustup default stable 1>/dev/null 2>/dev/null
    rustup toolchain install nightly
    rustup target add armv7-unknown-linux-musleabihf
    rustup target add armv7-unknown-linux-gnueabihf
    for cmd in "${INSTALL_COMMANDS[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            packages=""
            for item in "${INSTALL_COMMANDS[@]}"; do
                packages+=" $item"
            done
            ero "Install these commands by yourself:$packages"
            QOS_STOP=1
        fi
    done
}
check_for_tools

save_path() {
    if [ -z "$1" ]; then
        ero "Usage: save_path <name>"
        return 1
    fi
    
    local tempfile
    tempfile=$(mktemp -p /tmp/qos -u "$1.XXXXXX") || return 1
    
    pwd > "$tempfile"
    echo -n $(pwd)
}

restore_path() {
    if [ -z "$1" ]; then
        ero "Usage: restore_path <name>"
        return 1
    fi
    
    local tempfile
    tempfile=$(find /tmp/qos -type f -name "$1.*" | head -n 1)

    if [ -f "$tempfile" ]; then
        cd "$(cat "$tempfile")"
        echo "Path restored from: $tempfile"
        rm "$tempfile"
    else
        ero "No path found for $1"
    fi
}

function get_free_port() {
    comm -23 <(seq 49152 65535 | sort) <(ss -Htan | awk '{print $4}' | cut -d':' -f2 | sort -u) | shuf | head -n 1
}