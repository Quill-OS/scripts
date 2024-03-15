#!/bin/bash

save_path "rootfs"

block_size="1048576"
comp_alg="xz"
# zsh doesn't like many arguments inside one variable
# xz needes -Xdict-size 100% but it doesn't work for other comp alg. empty this or play with -Xstrategy
comp_opt_1="-Xdict-size"
comp_opt_2="100%"

rootfs_out="$INKBOX_REPO_PATHS/$INKBOX_OUT_DIR/rootfs.squashfs"

source build_fbink.sh

enter_repo "rootfs"

# Copy things
cp $FBINK_PATH_KOBO opt/bin/fbink/fbink-kobo
cp $FBDEPTH_PATH_KOBO opt/bin/fbink/fbdepth-kobo

# Qt platform plugin should be in gui bundle

git rev-parse HEAD > .commit
chmod u+s "bin/busybox"
find . -type f -name ".keep" -exec rm {} \;
rm -f $rootfs_out
# -wildcards and -e "*.keep" won't work
mksquashfs . $rootfs_out -b $block_size -comp $comp_alg $comp_opt_1 $comp_opt_2 -always-use-fragments -all-root -e .git -e .gitignore
rm -f .commit
find . -type d ! -path "*.git*" -empty -exec touch '{}'/.keep \;

source sign.sh "device" $rootfs_out

restore_path "rootfs"

echo "Root filesystem has been created."