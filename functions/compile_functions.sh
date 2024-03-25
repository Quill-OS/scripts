#!/bin/bash
icho "Loading compile functions"

CORES=$(nproc)

function compiler_path_add() {
    # export PATH=$PATH:$QOS_REPO_PATHS/kernel/toolchain/armv7l-linux-musleabihf-cross/bin
    # export PATH=$PATH:$QOS_REPO_PATHS/compiled-binaries/arm-kobo-linux-gnueabihf/bin/

    dir_path="$QOS_REPO_PATHS/kernel/toolchain/armv7l-linux-musleabihf-cross/bin"
    if [[ ":$PATH:" != *":$dir_path:"* ]]; then
        export PATH="$PATH:$dir_path"
        echo "Added $dir_path to PATH"
    #else
        #echo Directory is already in path: $dir_path
    fi

    dir_path="$QOS_REPO_PATHS/compiled-binaries/arm-kobo-linux-gnueabihf/bin/"
    if [[ ":$PATH:" != *":$dir_path:"* ]]; then
        export PATH="$PATH:$dir_path"
        echo "Added $dir_path to PATH"
    #else
        #echo Directory is already in path: $dir_path
    fi
}
compiler_path_add

function make_clean() {
    if [ "$QOS_CLEAN" = "1" ]; then
        make clean
        make distclean
    fi
}

function pull_submodules() {
    directory="$1"
    if [ -z "$(ls -A $directory 2>/dev/null)" ]; then
        git submodule update --init --recursive
    fi
}

function qos_qmake() {
    directory="$1"
    "${QOS_REPO_PATHS}/compiled-binaries/qt-bin/qt-linux-5.15.2-kobo/bin/qmake" $directory
}