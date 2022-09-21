#!/usr/bin/env sh

export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
[ ! -d "${XDG_DATA_HOME}" ] && mkdir -p "${XDG_DATA_HOME}"
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
[ ! -d "${XDG_CACHE_HOME}" ] && mkdir -p "${XDG_CACHE_HOME}"
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
[ ! -d "${XDG_CONFIG_HOME}" ] && mkdir -p "${XDG_CONFIG_HOME}"

if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        doas mkdir -p "${XDG_RUNTIME_DIR}"
        doas chown -R $(id -u):users "${XDG_RUNTIME_DIR}"
        doas chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi
