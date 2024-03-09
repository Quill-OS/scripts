#!/bin/bash

if [ -e "$script_dir/local_inkbox_settings.ini" ]; then
    source "$script_dir/local_inkbox_settings.ini"
    icho "Using local_inkbox_settings.ini from script directory: $script_dir"
else
    source "$script_dir/setup/inkbox_settings.ini"
    icho "Using inkbox_settings.ini from setup directory: $script_dir/setup/inkbox_settings.ini"
fi
