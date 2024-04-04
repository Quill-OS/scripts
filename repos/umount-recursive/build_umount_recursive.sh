#!/bin/bash

save_path "umount-recursive"
enter_repo "$UMOUNT_RECURSIVE_REPO"

cargo_clean

RUSTFLAGS="-Zlocation-detail=none" cross +nightly build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --target armv7-unknown-linux-musleabihf --release

restore_path "umount-recursive"