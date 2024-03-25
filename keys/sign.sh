#!/bin/bash

# If squashfs-root/qos exists, use keys from there - otherwise from tmp and if there are none - create them

function create_key() {
    local file="$1" # Without extension or anything
    private_key="$file-private.pem"
    public_key="$file-public.pem"
    save_path "create_key"
    cd "$QOS_REPO_PATHS/scripts/keys/tmp"
    openssl genrsa -out $private_key 2048
    openssl rsa -in $private_key -out $public_key -outform PEM -pubout
    restore_path "create_key"
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

key_path="" # Private one obviously

save_path "sign"
key_front_path="$QOS_REPO_PATHS/scripts/keys"
cd "$QOS_REPO_PATHS/scripts/keys"
case "$1" in
    device)
        kpath="squashfs-root/qos/$QOS_DEVICE/private.pem"
        if [ -f $kpath ]; then
            key_path="$key_front_path/$kpath"
        else
            key_path="$key_front_path/tmp/device-private.pem"
            if [ ! -f $key_path ]; then
                echo "Device key does not exist, creating one in tmp."
                create_key "device"
            fi
        fi
        ;;
    kobox)
        echo "TODO :P"
        ;;
    applications)
        echo "TODO :P"
        ;;
esac

restore_path "sign"

echo "Choosen key: $key_path"

file_to_sign=$2
signed_out="$file_to_sign.dgst"

openssl dgst -sha256 -sign $key_path -out $signed_out $file_to_sign