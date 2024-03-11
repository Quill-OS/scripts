#!/bin/bash
icho "Starting inkbox test"

if ping -c 1 "$INKBOX_IP" &> /dev/null; then
    icho "Ping to $INKBOX_IP successful."
    echo "Inkbox connection, script functions work correctly :D" > /tmp/inkbox_test.txt
    upload_file /tmp/inkbox_test.txt /tmp/
    exec_remote_rootfs "cp /tmp/inkbox_test.txt /kobo/tmp/" 2>&1 > /dev/null
    exec_remote_gui "cat /tmp/inkbox_test.txt"
    exec_remote_gui "rm /tmp/inkbox_test.txt"
    exec_remote_rootfs "killall -q -9 inkbox inkbox.sh inkbox-bin"
    exec_remote_rootfs "fbink -c -f -q"
    exec_remote_rootfs "fbink -c -f -q"
    exec_remote_rootfs "fbink -q -pmM -S 4 \"InkBox test done\""
else
    echo "Ping to $INKBOX_IP failed. can't connect to InkBox"
fi