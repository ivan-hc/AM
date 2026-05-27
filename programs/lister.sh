#!/bin/sh

DIRS=$(find . -type d | grep "/" | sed 's:.*/::')
for arch in $DIRS; do
	rm -f "$arch-appimages" "$arch-portable"
	ARGS=$(awk -v FS="(◆ | : )" '{print $2}' <"$arch-apps" | sort -u)
	for arg in $ARGS; do
		if [ -f "./$arch/$arg" ]; then
			grep "^◆ $arg :" "$arch-apps" | head -1 >> "$arch-tmplist"
			if grep -qe "appimageupdatetool" "./$arch/$arg" 1>/dev/null; then
				grep "◆ $arg :" "$arch-apps" | head -1 >> "$arch-appimages"
			else
				grep "◆ $arg :" "$arch-apps" | head -1 >> "$arch-portable"
			fi
		fi
	done
	if [ "$arch" = x86_64 ]; then
		METAPACKAGES="kdegames kdeutils node platform-tools"
		for m in $METAPACKAGES; do
			metapkg_page=$(curl -Ls --retry 5 --retry-max-time 120 "https://portable-linux-apps.github.io/apps/$m.md" 2>/dev/null)
			if [ -z "$metapkg_page" ]; then
				exit 1
			elif ! echo "$metapkg_page" | head -1 | grep -qi "^# $m"; then
				exit 1
			else
				echo "$metapkg_page" | grep -- " - .* : .*.$" | sed -- "s/^ - / ◆ /g; s/$/ This is part of \"$m\"./g" >> "$arch-tmplist"
			fi
		done
	fi
	[ -f "$arch-tmplist" ] && sort "$arch-tmplist" > "$arch-apps"
done
