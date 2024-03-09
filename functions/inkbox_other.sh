#!/bin/bash

function icho {
    local message="$1"
    if [ "$INKBOX_DEBUG_MESSAGES" = "1" ]; then
        echo $message
    fi
}