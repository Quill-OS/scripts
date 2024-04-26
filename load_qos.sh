#!/bin/bash

QOS_REPO_PATHS="/home/build/qos" # No / at the end

# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself?source=post_page-----b5fcee4b2a34--------------------------------
# What an awfull link
#script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# This doesn't always work, so we will go the dumb route.

excluded_dirs=(".git" "keys/tmp" "keys/squashfs-root" "img")

script_dir="$QOS_REPO_PATHS/scripts"

add_to_path() {
    dir_path="$1"

    match_found=false
    for excluded_dir in "${excluded_dirs[@]}"; do
        if [[ "$dir_path" == *"$excluded_dir"* ]]; then
            match_found=true
            break
        fi
    done

    if [ "$match_found" = true ]; then
        #echo "Directory $dir_path matches an excluded directory. Exiting."
        return 0
    fi

    if [[ ":$PATH:" != *":$dir_path:"* ]]; then
        export PATH="$PATH:$dir_path"
        echo "Added $dir_path to PATH"
    else
        icho "Directory is already in path: $dir_path"
    fi
}

directory_list=$(find ${script_dir} -type d)

while IFS= read -r dir; do
    add_to_path "$dir"
done <<< "$directory_list"

QOS_STOP=0

source qos_other.sh

source qos_load_variables.sh

source qos_other.sh # Second time because we want variables to work in some of the functions there

source qos_tools.sh
if tmp_file_check "tools"; then
    check_for_tools
    check_for_libs
else
    echo "Tools were already checked, skipping..."
fi

source qos_remote_functions.sh
get_device

source qos_compiled_paths.sh

source qos_compile_functions.sh
compiler_path_add

source qos_git_functions.sh

# Rest
mkdir -p "$QOS_REPO_PATHS/$QOS_OUT_DIR"
mkdir -p "$QOS_TMP"

if [ "$QOS_TEST" = 1 ] && [ "$QOS_STOP" = 0 ]; then
    # Source is needed here too, ( everywhere... ) welp
    source qos_test.sh
fi
QOS_STOP=0