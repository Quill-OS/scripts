#!/bin/bash

icho "Loading remote functions"

# Clones a repo to QOS_REPO_PATHS, the argument is the repo name
function clone_repo() {
    local repo_name="$1"

    repo_link=""
    if [ "$QOS_USE_GIT_HTTPS" = "1" ]; then
        repo_link="$QOS_HTTPS_LINK" 
    else
        repo_link="$QOS_SSH_LINK"
    fi
    repo_link="$repo_link/$repo_name.git"
    repo_path="$QOS_REPO_PATHS/$repo_name"

    if [ -z "$(ls -A $repo_path 2>/dev/null)" ]; then
        echo "Cloning repo: $repo_name"
        git clone --recurse-submodules $repo_link $repo_path
    else
        current_path=$(pwd)
        cd $repo_path
        echo "Pulling repo: $repo_name"
        git pull
        cd $current_path
    fi
}

function qos_get_all_repos() {
    icho "Getting all repos"

    link="$QOS_API_GITHUB_ORG_LINK/repos"

    curl -s $link | grep \"full_name\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | while read -r repo; do
        sub="$QOS_GITHUB_ORG/"
        real_repo_name="${repo//$sub}"
        clone_repo $real_repo_name
    done
}

ink_repos=("rootfs" "qt5-kobo-platform-plugin" "FBInk" "qos" "kernel" "gui-bundle" "oobe-qos" "imgtool" "recoveryfs" "gui-rootfs" "qos-power-daemon" "epubtool" "diagnostics" "lockscreen" "umount-recursive" "toolchains")

function qos_get_essential_repos() {
    icho "Getting essential repos"
    for repo in "${ink_repos[@]}"; do
        clone_repo $repo
    done
}

function enter_repo() {
    local repo="$1"

    cd $QOS_REPO_PATHS

    if [ -z "$(ls -A $repo 2>/dev/null)" ]; then
        icho "Repo $repo doesn't exist, cloning it..."
        clone_repo $repo
    fi

    cd $repo
}