#!/bin/sh

set -eu

generate_list() {
    file="$1"

    [ ! -f "$file" ] && { echo "Error: not found '$file'"; return; }

    name=$(basename "$file")
    type=$(sed -n "/^# Type:[\ ]*/{s///p;q}" "$file")
    description=$(sed -n "/^# Description:[\ ]*/{s///p;q}" "$file")

    if [ -z "$description" ]; then
        echo "Warn: not description: '$file' " >&2
    fi

    line="◆ $name : $description"

    if echo "$type" | grep -iqE "^(pkg2)?appimage$"; then
        echo "$line" >> "$arch-appimages"
    fi
    echo "$line" >> "$arch-apps"
}

DIRS=$(find . -type d | grep "/" | sed 's:.*/::')
[ $# -gt 0 ] && DIRS="$*"

for arch in $DIRS; do
    [ ! -d "$arch" ] && { echo "Error: directory not found: $arch"; continue; }
    echo "Info: Generate program list for '$arch'"

    [ -f "$arch-apps" ] && rm "$arch-apps"
    [ -f "$arch-appimages" ] && rm "$arch-appimages"

    find "$arch" -type f -print | sort | while IFS= read -r file; do
        generate_list "$file"
    done
done

