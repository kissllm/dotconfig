#!/usr/bin/env sh
wifi_mod="$(lsmod | grep "iwlmvm" | awk '{print $1}')"
[ -z "$wifi_mod" ] && modprobe iwlmvm
