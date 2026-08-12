#!/usr/bin/env sh
multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"

for var in WAYLAND_DISPLAY DISPLAY; do
    val=$(systemctl --user show-environment | sed -n "s/^$var=//p")
    [ -n "$val" ] && export "$var=$val"
done

if [ "$save" = "1" ]; then
    dir=$(dirname -- "$path")
    [ -d "$dir" ] || dir="$HOME"
    [ -e "$path" ] || : > "$path" 2>/dev/null
    set -- --chooser-file="$out" "$dir"
elif [ "$directory" = "1" ]; then
    [ -d "$path" ] || path="$HOME"
    set -- --cwd-file="$out" "$path"
else
    [ -e "$path" ] || path="$HOME"
    set -- --chooser-file="$out" "$path"
fi

exec kitty --class=file_chooser -e yazi "$@"
