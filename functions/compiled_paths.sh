#!/bin/bash# Fbink
FBINK_REPO="FBInk"
FBINK_PATH_KOBO="$QOS_REPO_PATHS/$FBINK_REPO/Release/fbink"
FBDEPTH_PATH_KOBO="$QOS_REPO_PATHS/$FBINK_REPO/Release/fbdepth"

# Qt platform plugin
QT_PLATFORM_PLUGIN_REPO="qt5-kobo-platform-plugin"
QT_PLATFORM_PLUGIN_PATH="$QOS_REPO_PATHS/$QT_PLATFORM_PLUGIN_REPO/build/ereader/libkobo.so"

# Rootfs
ROOTFS_OUT="$QOS_REPO_PATHS/$QOS_OUT_DIR/rootfs/rootfs.squashfs"
mkdir -p $(dirname $ROOTFS_OUT)