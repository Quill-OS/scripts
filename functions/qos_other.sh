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

# Example use: 
#if tmp_file_check "$file_name"; then
#    echo "Do something"
#fi
tmp_file_check() {
    file_path="$QOS_TMP/$1"
    if [ ! -f "$file_path" ]; then
        mkdir -p "$QOS_TMP"
        touch "$file_path"
        return 0
    else
        return 1
    fi
}