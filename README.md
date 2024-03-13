First, if you cloned this repo to an other path than `/home/build/inkbox` go to load_inkbox_scripts.sh and edit INKBOX_REPO_PATHS to your needs.

Then, to load all these commands ( and functions... ) to your PATH run:
```
source load_inkbox_scripts.sh
```
run all these commands with `source` or `. command`

to customise the settings (ip address of inkbox, username, password, etc) execute `create_personal_values.sh`. From now on values will be loaded from `local_inkbox_settings.ini`

to make all commands work without issues, run `prepare_inkbox` to set some flags. The device will be rebooted

If a command is needed and you don't have it, you will be promptet to install it. **If you are missing rust (the `cargo` command too) you need to install it manually.