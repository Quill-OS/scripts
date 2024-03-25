#!/bin/bash
if [ -e "$script_dir/local_qos_settings.ini" ]; then
    source "$script_dir/local_qos_settings.ini"
    icho "Using local_qos_settings.ini from script directory: $script_dir"
else
    source "$script_dir/setup/qos_settings.ini"
    icho "Using qos_settings.ini from setup directory: $script_dir/setup/qos_settings.ini"
fi
