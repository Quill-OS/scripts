#!/bin/bash

block_size="300K"
comp_alg="-comp xz -Xdict-size 100%"
rootfs_out="$INKBOX_REPO_PATHS/$INKBOX_OUT_DIR/rootfs.squashfs"

enter_repo

git rev-parse HEAD > .commit
chmod u+s "${GITDIR}/bin/busybox"
find . -type f -name ".keep" -exec rm {} \;
rm -f $rootfs_out
mksquashfs . $rootfs_out -b $block_size $comp_alg -always-use-fragments -all-root -e .git -e .gitignore
rm -f .commit
find . -type d ! -path "*.git*" -empty -exec touch '{}'/.keep \;

#echo "Root filesystem has been compressed."