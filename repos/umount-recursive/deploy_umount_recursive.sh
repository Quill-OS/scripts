#!/bin/bash

exec_remote_rootfs "rm -rf /tmp/umount-recursive"
upload_file "$UMOUNT_RECURSIVE_PATH" /tmp/