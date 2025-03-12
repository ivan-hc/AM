#!/bin/sh

DIRS=$(find . -type d | grep "/" | sed 's:.*/::')
for arch in $DIRS; do
	rm -f "$arch-appimages"
	ARGS=$(awk -v FS="(◆ | : )" '{print $2}' <"$arch-apps")
	for arg in $ARGS; do
		if grep -qe "appimageupdatetool" "./$arch/$arg" 1>/dev/null; then
			if ! grep "◆ $arg :" "$arch-apps" | grep -ie "\"kdegames\"\|\"kdeutils\"" 1>/dev/null; then
				grep "◆ $arg :" "$arch-apps" >> "$arch-appimages"
			fi
		fi
	done
done
