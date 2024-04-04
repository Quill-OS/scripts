#!/bin/bash
save_path "qt5-platform-plugin"
enter_repo "$QT_PLATFORM_PLUGIN_REPO"
pull_submodules "FBInk/i2c-tools"
make_clean
qos_qmake
make -j$CORES
arm-kobo-linux-gnueabihf-strip $QT_PLATFORM_PLUGIN_PATH
restore_path "qt5-platform-plugin"