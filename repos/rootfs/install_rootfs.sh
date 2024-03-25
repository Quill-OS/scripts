#!/bin/bash

exec_remote_rootfs "service qos_gui stop"
exec_remote_rootfs "killall squashfuse"
exec_remote_rootfs "killall unionfs"
exec_remote_init "pkill unionfs"
exec_remote_init "pkill qos-splash"
exec_remote_init "pkill /usr/bin/inkvt.armhf"
exec_remote_init "pkill initrd-fifo"
exec_remote_init "pkill openrc-run.sh"
exec_remote_init "pkill udhcpd"
exec_remote_init "pkill sshd"

rootfs_dir=$(dirname $ROOTFS_OUT)
free_port=$(get_free_port)

source run_http_server.sh $rootfs_dir $free_port &
sleep 3

exec_remote_init "umount /dev/mmcblk0p3"
exec_remote_init "mkdir /tmp/p3"
exec_remote_init "mount /dev/mmcblk0p3 /tmp/p3"

exec_remote_init "rm -f /tmp/p3/rootfs.squashfs"
exec_remote_init "rm -f /tmp/p3/rootfs.squashfs.dgst"

download_sign="wget -O /tmp/p3/rootfs.squashfs.dgst http://$QOS_HOST_IP:$free_port/rootfs.squashfs.dgst"
download_rootfs="wget -O /tmp/p3/rootfs.squashfs http://$QOS_HOST_IP:$free_port/rootfs.squashfs"

exec_remote_init $download_sign
exec_remote_init $download_rootfs

exec_remote_init "sync"
sleep 2
exec_remote_init "umount /tmp/p3"
sleep 3
exec_remote_init "reboot -f" &
sleep 5

echo "Rootfs installed, I hope"