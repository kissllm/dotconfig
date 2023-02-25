#!/bin/sh

export LOGNAME=$(/usr/bin/whoami)

KISS_PATH=''
export REPO_ROOT="/var/db/kiss"

[ -z "${KISS_DEBUG+x}" ] || {
    # Later ones have higher priority
    if [ -z "${KISS_PATH:+x}" ]; then
        KISS_PATH=$REPO_ROOT/kiss-repo-repos
    else
        KISS_PATH=$REPO_ROOT/kiss-repo-repos:$KISS_PATH
    fi

    KISS_PATH=$REPO_ROOT/repos/flatpak/flatpak:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/cemkeylan/personal:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/cemkeylan/editors:$KISS_PATH

    KISS_PATH=$REPO_ROOT/repos/containers:$KISS_PATH

    KISS_PATH=$REPO_ROOT/repos/eudaldgr/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/eudaldgr/libs:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/eudaldgr/garbage:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/eudaldgr/gfx:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/eudaldgr/java:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/eudaldgr/lxqt:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/eudaldgr/office:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/eudaldgr/python:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/eudaldgr/science:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/eudaldgr/themes:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/eudaldgr/video:$KISS_PATH

    KISS_PATH=$REPO_ROOT/repos/periish/audio:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/periish/cmd-utils:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/periish/containers:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/periish/dbus:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/periish/misc:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/periish/ricing:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/periish/xfce4:$KISS_PATH

    KISS_PATH=$REPO_ROOT/noir/wayland:$KISS_PATH
    KISS_PATH=$REPO_ROOT/noir/testing:$KISS_PATH
    KISS_PATH=$REPO_ROOT/noir/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/noir/core:$KISS_PATH

    KISS_PATH=$REPO_ROOT/sauzer/xorg:$KISS_PATH
    KISS_PATH=$REPO_ROOT/sauzer/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/sauzer/core:$KISS_PATH

    KISS_PATH=$REPO_ROOT/dm/im:$KISS_PATH
    KISS_PATH=$REPO_ROOT/dm/kernel:$KISS_PATH
    KISS_PATH=$REPO_ROOT/dm/site:$KISS_PATH

    KISS_PATH=$REPO_ROOT/repos/fonts/kiss-fonts:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/himmalerin/modified:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/himmalerin/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/dumpsterfire/wayland:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/dumpsterfire/desktop:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/dumpsterfire/xorg:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/dumpsterfire/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/dumpsterfire/core:$KISS_PATH

    KISS_PATH=$REPO_ROOT/kiss-somethingsomethingstatic/bin:$KISS_PATH
    KISS_PATH=$REPO_ROOT/kiss-somethingsomethingstatic/wayland:$KISS_PATH
    KISS_PATH=$REPO_ROOT/kiss-somethingsomethingstatic/community:$KISS_PATH
    KISS_PATH=$REPO_ROOT/kiss-somethingsomethingstatic/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/kiss-somethingsomethingstatic/core:$KISS_PATH

    # KISS_PATH=$REPO_ROOT/repo/wayland:$KISS_PATH
    # KISS_PATH=$REPO_ROOT/repo/testing:$KISS_PATH
    # KISS_PATH=$REPO_ROOT/repo/extra:$KISS_PATH
    # KISS_PATH=$REPO_ROOT/repo/core:$KISS_PATH

    # KISS_PATH=$REPO_ROOT/repos/mmatongo:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/jedahan:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/ioraff/modified:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/ioraff/dbus:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/ioraff/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/games/equipment:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/games/games:$KISS_PATH

    # KISS_PATH=$REPO_ROOT/repos/lang:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/lang/testing:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/lang/languages:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/lang/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/talyn:$KISS_PATH

    KISS_PATH=$REPO_ROOT/kiss-repo/dbus:$KISS_PATH
    KISS_PATH=$REPO_ROOT/kiss-repo/extra:$KISS_PATH
    # KISS_PATH=$REPO_ROOT/kiss-repo/modified:$KISS_PATH
    # KISS_PATH=$REPO_ROOT/kiss-repo/old:$KISS_PATH

    KISS_PATH=$REPO_ROOT/repos/community/wayland:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/community/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/repos/community/core:$KISS_PATH

    # KISS_PATH=$REPO_ROOT/glasnost/modules/community/community:$KISS_PATH
    # KISS_PATH=$REPO_ROOT/glasnost/modules/repo/wayland:$KISS_PATH
    # KISS_PATH=$REPO_ROOT/glasnost/modules/repo/extra:$KISS_PATH
    # KISS_PATH=$REPO_ROOT/glasnost/modules/repo/core:$KISS_PATH

    KISS_PATH=$REPO_ROOT/community/community:$KISS_PATH
    KISS_PATH=$REPO_ROOT/boost/community:$KISS_PATH
    KISS_PATH=$REPO_ROOT/wyverkkiss/wayland:$KISS_PATH
    KISS_PATH=$REPO_ROOT/wyverkkiss/gnu:$KISS_PATH
    KISS_PATH=$REPO_ROOT/wyverkkiss/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/wyverkkiss/core:$KISS_PATH

    KISS_PATH=$REPO_ROOT/dilyn/wayland:$KISS_PATH
    KISS_PATH=$REPO_ROOT/dilyn/gpl:$KISS_PATH
    KISS_PATH=$REPO_ROOT/dilyn/extra:$KISS_PATH
    KISS_PATH=$REPO_ROOT/dilyn/core:$KISS_PATH

    if [ -z "${KISS_PATH:+x}" ]; then
        KISS_PATH=$REPO_ROOT/kiss-llvm
    else
        KISS_PATH=$REPO_ROOT/kiss-llvm:$KISS_PATH
    fi

}


export REPO_MAIN="$REPO_ROOT/lm"

if [ -z "${KISS_PATH:+x}" ]; then
    KISS_PATH=$REPO_MAIN/fonts
else
    KISS_PATH=$REPO_MAIN/fonts:$KISS_PATH
fi
KISS_PATH=$REPO_MAIN/wayland:$KISS_PATH
KISS_PATH=$REPO_MAIN/system:$KISS_PATH
KISS_PATH=$REPO_MAIN/extra:$KISS_PATH
KISS_PATH=$REPO_MAIN/core:$KISS_PATH

# Static version will remove dynamic libraries
# KISS_PATH=$REPO_MAIN/static/bin:$KISS_PATH
# KISS_PATH=$REPO_MAIN/static/community:$KISS_PATH
# KISS_PATH=$REPO_MAIN/static/wayland:$KISS_PATH
# KISS_PATH=$REPO_MAIN/static/extra:$KISS_PATH
# KISS_PATH=$REPO_MAIN/static/core:$KISS_PATH

export ARCH="x86_64"
export KISS_XHOST_ARCH="$ARCH"
export KISS_XBUILD_ARCH="$KISS_XHOST_ARCH"
export CLIBC="musl"
export KISS_XHOST_ABI="$CLIBC"
export KISS_XBUILD_ABI="$KISS_XHOST_ABI"
export KISS_XHOST_TRIPLE="$KISS_XHOST_ARCH-linux-$KISS_XHOST_ABI"
export KISS_XBUILD_TRIPLE="$KISS_XBUILD_ARCH-linux-$KISS_XBUILD_ABI"


# For cports
export CHOST="${KISS_XHOST_TRIPLE}"
export CTARGET="${KISS_XHOST_TRIPLE}"
export CBUILD="${KISS_XBUILD_TRIPLE}"

export KISS_ROOT=
export KISS_PATH=$KISS_PATH
export KISS_REMOTE_REPO=$KISS_PATH

# https://github.com/glasnostlinux/glasnost/releases
# CFLAGS="-march=x86-64 -mtune=generic -pipe -Os"
# CFLAGS="--target=$KISS_XHOST_TRIPLE -Os -fPIC -no-pie"
# CFLAGS="--target=$KISS_XHOST_TRIPLE -Os -pipe -fPIC -mtune=native --host=x86_64"
# CFLAGS="--target=$KISS_XHOST_TRIPLE -Os -fPIC -mcpu=x86-64"
CFLAGS="--target=$KISS_XHOST_TRIPLE -O3 -pipe -fPIC -march=x86-64 -mtune=native"
CXXFLAGS="$CFLAGS"
CPPFLAGS="$CXXFLAGS"

export CFLAGS="$CFLAGS"
export CXXFLAGS="$CXXFLAGS"
export CPPFLAGS="$CXXFLAGS"

export MAKEFLAGS="-j $(($(nproc) + 1))"
export KISS_PROMPT=0
export KISS_TMPDIR="/tmp$HOME/kiss"
[ -d "$KISS_TMPDIR" ] || \mkdir -p "$KISS_TMPDIR"
export KISS_SRC_ROOT="/working/kiss"
[ -d "$KISS_SRC_ROOT" ] || \mkdir -p "$KISS_SRC_ROOT"
git config --global --add safe.directory "$KISS_SRC_ROOT"
