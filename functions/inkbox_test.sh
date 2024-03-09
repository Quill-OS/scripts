#!/bin/bash

icho "Starting inkbox test"

echo "Inkbox connection, script functions work correctly :D" > /tmp/inkbox_test.txt
upload_file /tmp/inkbox_test.txt /tmp/
exec_remote_rootfs "cp /tmp/inkbox_test.txt /kobo/tmp/"
exec_remote_gui "cat /tmp/inkbox_test.txt"
exec_remote_gui "rm /tmp/inkbox_test.txt"