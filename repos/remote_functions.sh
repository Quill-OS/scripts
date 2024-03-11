#!/bin/bash

icho "Loading remote functions"

# Clones a repo to INKBOX_REPO_PATHS, the argument is the repo name
function clone_repo() {
    local repo_name="$1"

    repo_link=""
    if [ "$INKBOX_USE_GIT_HTTPS" = "1" ]; then
        repo_link="$INKBOX_HTTPS_LINK" 
    else
        repo_link="$INKBOX_SSH_LINK"
    fi
    repo_link="$repo_link/$repo_name.git"
    repo_path="$INKBOX_REPO_PATHS/$repo_name"

    if [ -z "$(ls -A $repo_path)" ]; then
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

function inkbox_get_all_repos() {
    icho "Getting all repos"

    link="$INKBOX_API_GITHUB_ORG_LINK/repos"

    curl -s $link | grep \"full_name\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | while read -r repo; do
        sub="$INKBOX_GITHUB_ORG_NAME/"
        real_repo_name="${repo//$sub}"
        clone_repo $real_repo_name
    done
}

function inkbox_get_essential_repos() {
    icho "Getting essential repos"
}

function enter_repo() {
    local repo="$1"

    cd $INKBOX_REPO_PATHS

    if [ -z "$(ls -A $repo)" ]; then
        icho "Repo $repo doesn't exist, cloning it..."
        clone_repo $repo
    fi

    cd $repo
}