#!/bin/bash

# Running source run_http_server.sh $rootfs_dir & for example can, after it is finished will change the path back anyway
# Be aware of it

target_path="$1"
http_port="$2"

if [ -z "$target_path" ]; then
    ero "Usage: run_http_server.sh target_path http_port"
    return 1
fi

if [ -z "$http_port" ]; then
    ero "Usage: run_http_server.sh target_path http_port"
    return 1
fi

save_path "send-http-server"
enter_repo "send-http-server"
cargo run --release -- -t "$target_path" -p $http_port
restore_path "send-http-server"