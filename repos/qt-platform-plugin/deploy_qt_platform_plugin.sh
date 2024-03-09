#!/bin/bash

exec_remote_rootfs "killall -9 inkbox inkbox-bin 2048 2048-bin"
exec_remote_rootfs "umount /kobo/mnt/onboard/.adds/qt-linux-5.15.2-kobo/plugins/platforms/libkobo.so"
exec_remote_rootfs "rm /tmp/libkobo.so"
upload_file build/ereader/libkobo.so /tmp/
exec_remote_rootfs "mount --bind /tmp/libkobo.so /kobo/mnt/onboard/.adds/qt-linux-5.15.2-kobo/plugins/platforms/libkobo.so"
exec_remote_gui "env LD_LIBRARY_PATH=/mnt/onboard/.adds/qt-linux-5.15.2-kobo/lib:/lib/:/usr/lib QT_QPA_PLATFORM=kobo:debug /mnt/onboard/.adds/inkbox/2048-bin"