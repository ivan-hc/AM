#!/bin/sh

set -eu

get_program_type() {
    [ $# -ne 2 ] && { echo "need 2 args" >&2; exit 1; }
    arch="$1"
    program_name="$2"
    file="$arch/$program_name"

    if grep -qe 'APP=ffwa-*' "$file"; then
        echo "webapp"
        return
    elif grep -qe '--pbundle_desktop' "$file"; then
        echo "appbundle"
        return
    elif grep -qe '\./appimagetool \./pkg2appimage' "$file" \
    || grep -qE 'SITE="ivan-hc/(KDE[^ ]*|Data[^ ]*pkg2)appimage' "$file"; then
        echo "pkg2appimage"
        return
    #elif grep -qe '--appimage-extract' "$file" \
    #|| grep -e 'version=' "$file" | grep -iqE '[\.\ ]{1}appimage[^a-zA-Z0-9_-]|(\*)mage|mage(\$)' \
    #&& ! echo "$program_name" | grep -qwE '[^ ]*flatimage|rimage|gameimage'; then
        #echo "appimage"
        #return
    elif grep -iq '◆ '"$program_name"' :' "$arch-appimages"; then
        echo "appimage"
        return
    elif grep -qe 'AM-rollback' "$file"; then
        echo "roolback"
        return
    else
        echo "archive"
    fi
}

DIRS=$(find . -type d | grep "/" | sed 's:.*/::')
for arch in $DIRS; do
    [ ! -f "$arch-apps" ] && continue

    while IFS= read -r line; do
        program_name=$(echo "$line" | awk '{print $2}')
        description=$(echo "$line" | sed 's/◆ [^ ]* : //')

        file="$arch/$program_name"

        if [ ! -f "$file" ]; then
            echo "Error: not found: '$file' " >&2
            continue
        fi

        program_type=$(get_program_type "$arch" "$program_name")

        insert_string="# Type: $program_type\n# Description: $description"
        sed -i '2 i '"$insert_string"'' "$file"

    done < "$arch-apps"
done

