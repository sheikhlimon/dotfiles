#!/bin/bash
export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_DESKTOP=gnome
export GNOME_KEYRING_CONTROL=/run/user/$(id -u)/keyring
export ELECTRON_OZONE_PLATFORM_HINT=wayland
exec mongodb-compass --ignore-additional-command-line-flags "$@"
