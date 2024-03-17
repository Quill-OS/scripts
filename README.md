First, if you cloned this repo to an other path than `/home/build/inkbox` go to load_inkbox_scripts.sh and edit INKBOX_REPO_PATHS to your needs.

Then, to load all these commands ( and functions... ) to your PATH run:
```
source load_inkbox_scripts.sh
```
run all these commands with `source` or `. command`

to customise the settings (ip address of inkbox, username, password, etc) execute `create_personal_values.sh`. From now on values will be loaded from `local_inkbox_settings.ini`

On first connection, connect to the device manually for fingerprint ssh fun. If you are using many inkbox devices, consider doing this horrible thing. In `~/.ssh/config` put:
```
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
```

If your system doesn't request DHCP on the usbnet automatically, use `nmtui` and in the interface name set the MAC address from `remote_functions.sh` file. You will find it.

to make all commands work without issues, run `prepare_inkbox` to set some flags. The device will be rebooted

If a command is needed and you don't have it, you will be promptet to install it. **If you are missing rust (the `cargo` command too)** you need to install it manually. That's because there are many ways to install it (remote script, package manager)

## Keys
keys will be generated automatically in `keys/tmp/`. If you want to provide existing ones, do it in:
- `keys/squashfs-root/inkbox/device-id-like-n306/private.pem` and public.pem in the same directory for device specific key
- `keys/squashfs-root/applications/` for user apps
- `keys/squashfs-root/kobox/`: `graphic` dir and `nographic` dir

TLDR:
![key-tree](img/key-tree.png)