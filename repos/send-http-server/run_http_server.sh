#!/bin/bash

path="$1"

if [ -z "$path" ]; then
    echo "Usage: run_http_server.sh <command>"
    return 1
fi

cpath=$(pwd)
clone_repo "send-http-server"
cd "$INKBOX_REPO_PATHS/send-http-server"
cargo run --release -- -d "$cpath/$path"
cd $cpath