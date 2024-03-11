#!/bin/bash
enter_repo "qt5-kobo-platform-plugin"
pull_submodules "FBInk/i2c-tools"
make_clean
inkbox_qmake
make -j$CORES
arm-kobo-linux-gnueabihf-strip $QT_PLATFORM_PLUGIN_PATH