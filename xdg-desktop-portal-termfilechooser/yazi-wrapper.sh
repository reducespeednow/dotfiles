#!/usr/bin/env sh

export WAYLAND_DISPLAY=$(systemctl --user show-environment | grep '^WAYLAND_DISPLAY=' | cut -d= -f2)
export DISPLAY=$(systemctl --user show-environment | grep '^DISPLAY=' | cut -d= -f2)

kitty --class=file_chooser -e yazi --chooser-file="$5" "$4"
