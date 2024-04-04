#!/bin/bash
save_path "fbink"
enter_repo "$FBINK_REPO"
pull_submodules "i2c-tools"
make_clean
make -j$CORES static KOBO=1 MINIMAL=1 BITMAP=1 OPENTYPE=1 IMAGE=1 STATIC_LIBM=1 USE_STATIC_LIB=1 BUILD_STATIC_LIB=1 CROSS_COMPILE=armv7l-linux-musleabihf-
make -j$CORES fbdepth KOBO=1 MINIMAL=1 BITMAP=1 OPENTYPE=1 IMAGE=1 STATIC_LIBM=1 USE_STATIC_LIB=1 BUILD_STATIC_LIB=1 CROSS_COMPILE=armv7l-linux-musleabihf-
armv7l-linux-musleabihf-strip $FBINK_PATH_KOBO
armv7l-linux-musleabihf-strip $FBDEPTH_PATH_KOBO
restore_path "fbink"