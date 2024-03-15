#!/bin/bash# Fbink
FBINK_REPO="FBInk"
FBINK_PATH_KOBO="$INKBOX_REPO_PATHS/$FBINK_REPO/Release/fbink"
FBDEPTH_PATH_KOBO="$INKBOX_REPO_PATHS/$FBINK_REPO/Release/fbdepth"

# Qt platform plugin
QT_PLATFORM_PLUGIN_REPO="qt5-kobo-platform-plugin"
QT_PLATFORM_PLUGIN_PATH="$INKBOX_REPO_PATHS/$QT_PLATFORM_PLUGIN_REPO/build/ereader/libkobo.so"

# Rootfs
ROOTFS_OUT="$INKBOX_REPO_PATHS/$INKBOX_OUT_DIR/rootfs/rootfs.squashfs"
mkdir -p $(dirname $ROOTFS_OUT)