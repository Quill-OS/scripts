#!/bin/bash

# If squashfs-root/inkbox exists, use keys from there - otherwise from tmp and if there are none - create them

function create_key() {
    local path="$1"

}

if [ $# -ne 2 ]; then
    ero "Usage: $0 <device|kobox|applications> <file>"
    return
fi

case "$1" in
    device|kobox|applications)
        ;;
    *)
        ero "Invalid option. Please specify 'device', 'kobox', or 'applications'."
        return
        ;;
esac

if [ ! -f "$2" ]; then
    ero "Error: $2 is not a valid file."
    return
fi

key_path=""

