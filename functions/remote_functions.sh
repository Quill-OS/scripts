#!/bin/bash
icho "Loading remote functions"

function upload_file() {
    local local_file="$1"
    local remote_path="$2"

    if [ -z "$local_file" ] || [ -z "$remote_path" ]; then
        echo "Usage: upload_file <local_file> <remote_path>"
        return 1
    fi

    sshpass -p "$INKBOX_PASSWORD" scp "$local_file" "$INKBOX_USERNAME@$INKBOX_IP:$remote_path"

    if [ $? -eq 0 ]; then
        icho "$local_file successfully uploaded to $INKBOX_IP:$remote_path"
    else
        icho "Error uploading file. Check the credentials (or ssh key conflicts) and try again."
    fi
}

function exec_remote_rootfs() {
    local command_to_execute="$1"

    if [ -z "$command_to_execute" ]; then
        echo "Usage: execute_remote_command <command>"
        return 1
    fi

    sshpass -p "$INKBOX_PASSWORD" ssh -t -q "$INKBOX_USERNAME@$INKBOX_IP" "$command_to_execute"

    if [ $? -eq 0 ]; then
        icho "$command_to_execute executed successfully on $INKBOX_IP for rootfs"
    else
        icho "Error executing $command_to_execute. Check the credentials, syntax and try again."
    fi
}

function exec_remote_gui() {
    local command_to_execute="$1"

    if [ -z "$command_to_execute" ]; then
        echo "Usage: execute_remote_command <command>"
        return 1
    fi

    sshpass -p "$INKBOX_PASSWORD" ssh -t -q "$INKBOX_USERNAME@$INKBOX_IP" "chroot /kobo /bin/sh -c '$command_to_execute'"

    if [ $? -eq 0 ]; then
        icho "$command_to_execute executed successfully on $INKBOX_IP for gui"
    else
        icho "Error executing $command_to_execute. Check the credentials, syntax and try again."
    fi
}

function exec_remote_gui_telnet() {
    local command_to_execute="$1"

    if [ -z "$command_to_execute" ]; then
        echo "Usage: exec_remote_gui_telnet <command>"
        return 1
    fi

    cmd="\"/bin/sh -c \'$command_to_execute\'\r\""
    expect_script=$(mktemp)
    {
        echo '#!/usr/bin/expect'
        echo 'set timeout 20'
        echo 'set name '"$INKBOX_IP"
        echo 'set user '"$INKBOX_USERNAME"
        echo 'set password '"$INKBOX_PASSWORD"
        echo 'spawn telnet $name'
        echo 'expect "kobo login:"'
        echo 'send "$user\r"'
        echo 'expect "#"'
        echo "send $cmd"
        echo 'expect "~ #"'
        echo 'exit'
    } > "$expect_script"

    chmod +x "$expect_script"
    "$expect_script"

    rm "$expect_script"
}

function login_inkbox() {
    sshpass -p "$INKBOX_PASSWORD" ssh "$INKBOX_USERNAME@$INKBOX_IP"
}

function sshfs_inkbox() {
    sshfs_path="/mnt/inkbox"
    if [ -z "$(ls -A $sshfs_path 2>/dev/null)" ]; then
        sudo mkdir -p $sshfs_path
        sudo chown $USER:$USER $sshfs_path
    fi
    # sshpass won't work here
    sshfs "$INKBOX_USERNAME@$INKBOX_IP:/" $sshfs_path
}

function prepare_inkbox() {
    exec_remote_rootfs "echo true > /boot/flags/USBNET_ENABLE"
    exec_remote_rootfs "echo true > /boot/flags/RW_ROOTFS"
    exec_remote_rootfs "echo true > /boot/flags/INITRD_DEBUG"
    exec_remote_rootfs "echo true > /boot/flags/GUI_DEBUG"
    exec_remote_rootfs "echo true > /boot/flags/IPD_DEBUG"
    exec_remote_rootfs "echo 08:8c:24:48:ed:b3 > /boot/flags/USBNET_HOST_ADDRESS"
    exec_remote_rootfs "echo 5c:49:73:21:f2:bf > /boot/flags/USBNET_DEVICE_ADDRESS"
    exec_remote_rootfs "reboot"
}

function get_device() {
    if [[ -n $INKBOX_DEVICE_OVERWRITE ]]; then
        INKBOX_DEVICE="$INKBOX_DEVICE_OVERWRITE"
        echo "Your device is $INKBOX_DEVICE because of overwrite"
    else
        DETECTED_INKBOX_DEVICE=$(exec_remote_rootfs "cat /opt/inkbox_device")
        if [[ -n $DETECTED_INKBOX_DEVICE && ${#DETECTED_INKBOX_DEVICE} -ge 3 && ${#DETECTED_INKBOX_DEVICE} -le 6 ]]; then
            INKBOX_DEVICE=$(echo $DETECTED_INKBOX_DEVICE | tr -d '\n\t\r ') # Cleaning is needed
            echo "Your device is $INKBOX_DEVICE because of detection"
        else
            ero "Device is not set and couldn't be detected. Some commands may error out. Be aware of it and don't try to go to me if you get this error and won't read it. It's in red, so it's important right?"
        fi
    fi
}
get_device