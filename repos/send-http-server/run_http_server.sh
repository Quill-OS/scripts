#!/bin/bash

# Running source run_http_server.sh $rootfs_dir & for example can, after it is finished will change the path back anyway
# Be aware of it

path="$1"

if [ -z "$path" ]; then
    echo "Usage: run_http_server.sh <command>"
    return 1
fi

save_path "send-http-server"
enter_repo "send-http-server"
cargo run --release -- -t "$path"
restore_path "send-http-server"