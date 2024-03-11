#!/bin/bash

INKBOX_REPO_PATHS="/home/build/inkbox" # No / at the end

# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself?source=post_page-----b5fcee4b2a34--------------------------------
# What an awfull link
#script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# This doesn't always work, so we will go the dumb route.

excluded_dirs=(".git")

script_dir="$INKBOX_REPO_PATHS/scripts"

add_directory_to_path() {
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
        echo Directory is already in path: $dir_path
    fi
}

directory_list=$(find ${script_dir} -type d)

while IFS= read -r dir; do
    add_directory_to_path "$dir"
done <<< "$directory_list"

INKBOX_STOP=0
source inkbox_other.sh
source load_inkbox_variables.sh
source remote_functions.sh
source compiled_paths.sh
source compile_functions.sh
source remote_functions.sh

if [ "$INKBOX_STOP" = 0 ]; then
    # Source is needed here too, welp
    source inkbox_test.sh
fi
INKBOX_STOP=0