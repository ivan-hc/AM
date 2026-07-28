#!/bin/sh

rm -f "stats-appimages" "stats-portable"

_stats_appimages() {
	if [ "$arch" = x86_64 ]; then
		if grep -q "appimage-extract .*.desktop\|appimage-extract .*share/applications\|^mv .*usr/local/share/applications\|HEREDOC.*usr/local/share/applications" "./$arch/$arg"; then
			grep "◆ $arg :" "$arch-apps" | head -1 | sed 's/$/ #itsdesktopapp/' >> "stats-appimages"
		else
			grep "◆ $arg :" "$arch-apps" | head -1 | sed 's/$/ #itscliapp/' >> "stats-appimages"
		fi
	fi
}

_stats_portable2appimage() {
	if [ "$arch" = x86_64 ]; then
		if grep -qi "^curl.*.sh.*chmod.*&&\|^curl.*main/portable2appimage" "./$arch/$arg"; then
			grep "◆ $arg :" "$arch-apps" | head -1 | sed 's/$/ #itsappimageonthefly/' >> "stats-portable"
		fi
	fi
}

_stats_portable() {
	if [ "$arch" = x86_64 ]; then
		if grep -q "\[Desktop Entry\]" "./$arch/$arg"; then
			grep "◆ $arg :" "$arch-apps" | head -1 | sed 's/$/ #itsdesktopapp/' >> "stats-portable"
		elif ! grep -q "#printf.*AM.desktop" "./$arch/$arg" && grep -q "AM.desktop" "./$arch/$arg"; then
			grep "◆ $arg :" "$arch-apps" | head -1 | sed 's/$/ #itsdesktopapp/' >> "stats-portable"
		else
			grep "◆ $arg :" "$arch-apps" | head -1 | sed 's/$/ #itscliapp/' >> "stats-portable"
		fi
	fi
}

DIRS=$(find . -type d | grep "/" | sed 's:.*/::')
for arch in $DIRS; do
	rm -f "$arch-appimages" "$arch-portable"
	ARGS=$(awk -v FS="(◆ | : )" '{print $2}' <"$arch-apps" | sort -u)
	for arg in $ARGS; do
		if [ -f "./$arch/$arg" ]; then
			grep "^◆ $arg :" "$arch-apps" | head -1 >> "$arch-tmplist"
			if grep -qe "appimageupdatetool" "./$arch/$arg" 1>/dev/null; then
				grep "◆ $arg :" "$arch-apps" | head -1 >> "$arch-appimages"
				_stats_appimages
				_stats_portable2appimage
			else
				grep "◆ $arg :" "$arch-apps" | head -1 >> "$arch-portable"
				_stats_portable
			fi
		fi
	done
	if [ "$arch" = x86_64 ]; then
		METAPACKAGES="kdegames kdeutils node platform-tools"
		for m in $METAPACKAGES; do
			mpkgs_args=$(grep -Eo "METAPKG=.*" "./$arch/$m" | head -1 | tr '"' '\n' | grep "[a-z]")
			metapkg_page=$(curl -Ls --retry 5 --retry-max-time 120 "https://portable-linux-apps.github.io/apps/$m.md" 2>/dev/null)
			if [ -z "$metapkg_page" ]; then
				exit 1
			elif ! echo "$metapkg_page" | head -1 | grep -qi "^# $m"; then
				exit 1
			else
				for a in $mpkgs_args; do
					if ! grep -q "◆ $a :" "$arch-tmplist"; then
						echo "$metapkg_page" | grep -- " - $a : .*.$" | sed -- "s/^ - /◆ /g; s/$/ This is part of \"$m\"./g" >> "$arch-tmplist"
					fi
				done
			fi
		done
	fi
	[ -f "$arch-tmplist" ] && sort "$arch-tmplist" > "$arch-apps"
	rm -f "$arch-tmplist"
done
