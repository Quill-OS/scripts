#!/bin/bash

function icho() {
    local message="$1"
    if [ "$INKBOX_DEBUG_MESSAGES" = "1" ]; then
        echo $message
    fi
}

function enter_repo() {
    local repo="$1"

    cd $INKBOX_REPO_PATHS

    if [ -z "$(ls -A $repo)" ]; then
        REPO_URL="https://github.com/Kobo-InkBox/$repo.git"
        icho "Repo $repo doesn't exist, cloning it..."
        git clone --recurse-submodules $REPO_URL
    fi

    cd $repo
}