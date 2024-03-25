#!/bin/bash
icho "Starting qos test"

if ping -c 1 "$QOS_IP" &> /dev/null; then
    icho "Ping to $QOS_IP successful."
    echo "qos connection, script functions work correctly :D" > /tmp/qos_test.txt
    upload_file /tmp/qos_test.txt /tmp/
    exec_remote_rootfs "cp /tmp/qos_test.txt /kobo/tmp/" 2>&1 > /dev/null
    exec_remote_gui "cat /tmp/qos_test.txt"
    exec_remote_gui "rm /tmp/qos_test.txt"
    exec_remote_rootfs "killall -q -9 qos qos.sh qos-bin"
    exec_remote_rootfs "fbink -c -f -q"
    exec_remote_rootfs "fbink -c -f -q"
    exec_remote_rootfs "fbink -q -pmM -S 4 \"qos test done\""
else
    echo "Ping to $QOS_IP failed. can't connect to qos"
fi