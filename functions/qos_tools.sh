#!/bin/bash

function install_debian_packages() {
    echo "Installing needed packages with apt-get..."
    sudo apt-get install git openssh-server sshpass squashfs-tools sshfs expect pkg-config libssl-dev
    # They removed the UPX package -_-
    mkdir -p binaries
    cd binaries
    wget https://github.com/upx/upx/releases/download/v4.2.3/upx-4.2.3-amd64_linux.tar.xz
    tar -xf upx-4.2.3-amd64_linux.tar.xz
    mv upx-4.2.3-amd64_linux/upx .
    rm -rf upx-4.2.3*
    chmod +x upx
    cd ..
    add_to_path "binaries"
}

function install_arch_packages() {
    echo "Installing needed packages with pacman..."
    sudo pacman -S git openssh sshpass squashfs-tools sshfs expect pkgconf openssl upx
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

NEEDED_COMMANDS=("ssh" "git" "sshpass" "mksquashfs" "sshfs" "expect" "upx")
INSTALL_COMMANDS=("cargo")

# Yes, host libs
NEEDED_LIBS=("libssl")

function check_for_libs() {
    packages=""
    for item in "${NEEDED_LIBS[@]}"; do
        packages+=" $item"
    done
    echo "Checking for libs:$packages"

    for lib in "${NEEDED_LIBS[@]}"; do
        pkg-config --exists $lib || install_packages
    done
}

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

    # Rust
    . "$HOME/.cargo/env" 1>/dev/null 2>/dev/null
    rustup default stable 1>/dev/null 2>/dev/null
    rustup toolchain install nightly
    rustup target add armv7-unknown-linux-musleabihf
    rustup target add armv7-unknown-linux-gnueabihf
    cargo install cross

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

    # Stupid debian but whatever, add it everywhere
    add_to_path "binaries"
}