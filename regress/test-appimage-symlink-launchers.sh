#!/usr/bin/env sh

set -u

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

cd "$tmpdir" || exit 1
APP=tura
mkdir -p squashfs-root/share/applications applications icons || exit 1

cat > squashfs-root/share/applications/tura.desktop <<'EOF'
[Desktop Entry]
Name=Tura
Exec=tura
Icon=tura
EOF

ln -s ./share/applications/tura.desktop squashfs-root/tura.desktop || exit 1
ln -s missing-icon.png DirIcon || exit 1

cat > "$APP" <<'EOF'
#!/usr/bin/env sh
if [ "${1:-}" = "--appimage-extract" ] && [ "${2:-}" = "missing-icon.png" ]; then
	mkdir -p squashfs-root
	: > squashfs-root/missing-icon.png
	exit 0
fi

mkdir -p squashfs-root/share/applications
cat > squashfs-root/share/applications/tura.desktop <<'EOD'
[Desktop Entry]
Name=Tura
Exec=tura
Icon=tura
EOD
exit 0
EOF
chmod +x "$APP" || exit 1
: > remove

COUNT=0
while [ "$COUNT" -lt 10 ]; do
	DESKTOP_SYMLINKS=0
	for f in squashfs-root/*.desktop; do
		[ -e "$f" ] || continue
		FILE="$f"
		if [ -L "$f" ]; then
			DESKTOP_SYMLINKS=1
			LINKPATH="$(readlink "$f" | sed 's|^\./||' 2>/dev/null)"
			./"$APP" --appimage-extract "$LINKPATH" 1>/dev/null
			FILE="./squashfs-root/$LINKPATH"
			rm -f "$f"
		fi
		if grep -qi '^NoDisplay=true$' "$FILE" 2>/dev/null; then mv "$FILE" ./"$APP"-handler-AM.desktop && printf '\n%s' "rm -f /usr/local/share/applications/$APP-handler-AM.desktop" >> ./remove
		else [ ! -f ./"$APP"-AM.desktop ] && mv "$FILE" ./"$APP"-AM.desktop || mv "$FILE" ./"$APP"-"$COUNT"-AM.desktop && printf '\n%s' "rm -f /usr/local/share/applications/$APP-$COUNT-AM.desktop" >> ./remove
		fi
	done
	if [ -L ./DirIcon ]; then
		LINKPATH="$(readlink ./DirIcon | sed 's|^\./||' 2>/dev/null)"
		./"$APP" --appimage-extract "$LINKPATH" 1>/dev/null && mv ./squashfs-root/"$LINKPATH" ./DirIcon
	fi
	[ "$DESKTOP_SYMLINKS" -eq 0 ] && [ ! -L ./DirIcon ] && break
	COUNT=$((COUNT + 1))
done

desktop_count=$(find . -maxdepth 1 -name '*-AM.desktop' | wc -l | sed 's/ //g')

if [ "$desktop_count" != "1" ] || [ ! -f ./"$APP"-AM.desktop ]; then
	printf 'Expected exactly one desktop launcher, found %s\n' "$desktop_count" >&2
	find . -maxdepth 1 -name '*-AM.desktop' -print >&2
	exit 1
fi

printf 'PASS: symlinked desktop launcher is not duplicated\n'
