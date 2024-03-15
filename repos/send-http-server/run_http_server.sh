#!/bin/bash

path="$1"

if [ -z "$path" ]; then
    echo "Usage: run_http_server.sh <command>"
    return 1
fi

cpath_rhs=$(save_path "send-http-server")
clone_repo "send-http-server"
cd "$INKBOX_REPO_PATHS/send-http-server"
cargo run --release -- -t "$cpath_rhs/$path"
restore_path "send-http-server"