#!/bin/bash

exec_remote_rootfs "service inkbox_gui stop"
exec_remote_rootfs "killall squashfuse"
exec_remote_rootfs "killall unionfs"
exec_remote_init "pkill unionfs"
exec_remote_init "inkbox-splash"
exec_remote_init "/usr/bin/inkvt.armhf"
exec_remote_init "initrd-fifo"
exec_remote_init "openrc-run.sh"
exec_remote_init "udhcpd"
exec_remote_init "sshd"

rootfs_dir=$(dirname $ROOTFS_OUT)

source run_http_server.sh $rootfs_dir &
sleep 3

exec_remote_init "umount /dev/mmcblk0p3"
exec_remote_init "mkdir /tmp/p3"
exec_remote_init "mount /dev/mmcblk0p3 /tmp/p3"

exec_remote_init "rm -f /tmp/p3/rootfs.squashfs"
exec_remote_init "rm -f /tmp/p3/rootfs.squashfs.dgst"

download_rootfs=""

wget -O /tmp/p3/rootfs.squashfs.dgst http://192.168.2.3:8766/rootfs.squashfs.dgst

DEFAULT_SEND_HTTP_SERVER_PORT

INKBOX_HOST_IP
