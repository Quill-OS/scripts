#!/bin/bash

cd "${INKBOX_REPO_PATHS}/qt5-kobo-platform-plugin"

directory="FBInk/i2c-tools"
if [ -z "$(ls -A $directory)" ]; then
    git submodule update --init --recursive
fi
export PATH=$PATH:$INKBOX_REPO_PATHS/compiled-binaries/arm-kobo-linux-gnueabihf/bin/
make distclean

"${INKBOX_REPO_PATHS}/compiled-binaries/qt-bin/qt-linux-5.15.2-kobo/bin/qmake" .

make -j"$(nproc)"