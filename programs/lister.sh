#!/bin/sh

rm -f "stats-appimages" "stats-portable"

# Max parallel workers (override with: JOBS=8 ./script.sh)
JOBS=${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)}
case $JOBS in ''|*[!0-9]*) JOBS=4 ;; esac

# Append stdin to file $1 with suffix $2 -- shell builtins only, no forked sed
_add() {
	while IFS= read -r l; do
		printf '%s %s\n' "$l" "$1"
	done
}

_run_lister() {
	[ -f "./$arch/$arg" ] || return

	# Look up the app's line ONCE and reuse it (was grepped 3-4x per app)
	line=$(grep "◆ $arg :" "$arch-apps")

	if [ "$arch" = aarch64 ]; then
		xl=$(grep "^◆ $arg :" "x86_64-apps")   # was grepped twice
		if [ -n "$xl" ]; then
			printf '%s\n' "$xl" >> "$arch-tmplist"
		elif [ -n "$line" ]; then
			printf '%s\n' "$line" >> "$arch-tmplist"
		fi
	elif [ -n "$line" ]; then
		printf '%s\n' "$line" >> "$arch-tmplist"
	fi

	# Classify the install script in ONE pass (replaces 2-5 greps)
	class=$(awk '
		/appimageupdatetool/ { u = 1 }
		/appimage-extract .*.desktop|appimage-extract .*share\/applications|^mv .*usr\/local\/share\/applications|HEREDOC.*usr\/local\/share\/applications/ { d = 1 }
		tolower($0) ~ /^curl.*.sh.*chmod.*&&|^curl.*main\/portable2appimage/ { p = 1 }
		/\[Desktop Entry\]/	{ de = 1 }
		/#printf.*AM\.desktop/ { dis = 1 }
		/AM\.desktop/		  { am = 1 }
		END {
			s = ""
			if (u) s = s "u"
			if (d) s = s "D"
			if (p) s = s "P"
			if (de || (am && !dis)) s = s "d"
			else s = s "c"
			print s
		}
	' "./$arch/$arg")

	case $class in
	*u*)	# has appimageupdatetool
		[ -n "$line" ] && printf '%s\n' "$line" >> "$arch-appimages"
		if [ "$arch" = x86_64 ]; then
			case $class in
			*D*) [ -n "$line" ] && printf '%s\n' "$line" | _add "#itsdesktopapp" >> "stats-appimages" ;;
			*)   [ -n "$line" ] && printf '%s\n' "$line" | _add "#itscliapp"	 >> "stats-appimages" ;;
			esac
			case $class in
			*P*) [ -n "$line" ] && printf '%s\n' "$line" | _add "#itsappimageonthefly" >> "stats-portable" ;;
			esac
		fi
		;;
	*)	# portable
		[ -n "$line" ] && printf '%s\n' "$line" >> "$arch-portable"
		if [ "$arch" = x86_64 ]; then
			case $class in
			*d*) [ -n "$line" ] && printf '%s\n' "$line" | _add "#itsdesktopapp" >> "stats-portable" ;;
			*)   [ -n "$line" ] && printf '%s\n' "$line" | _add "#itscliapp"	 >> "stats-portable" ;;
			esac
		fi
		;;
	esac
}

DIRS=$(find . -type d | grep "/" | sed 's:.*/::' | grep -v x86_64 | xargs)
DIRS="x86_64 $DIRS"

for arch in $DIRS; do
	echo "Update $arch lists..."
	rm -f "$arch-appimages" "$arch-portable"

	ARGS=$(awk -v FS="(◆ | : )" '{print $2}' <"$arch-apps" | sort -u)

	# Run workers in batches of $JOBS instead of one unbounded job per app
	i=0
	for arg in $ARGS; do
		_run_lister &
		i=$((i + 1))
		[ $((i % JOBS)) -eq 0 ] && wait
	done
	wait

	for type in appimages portable; do
		if [ -f "$arch-$type" ]; then
			sort -u "$arch-$type" > list && mv list "$arch-$type"
		fi
		if [ "$arch" = x86_64 ] && [ -f "stats-$type" ]; then
			sort -u "stats-$type" > list && mv list "stats-$type"
		fi
	done

	if [ "$arch" = x86_64 ]; then
		METAPACKAGES="kdegames kdeutils node platform-tools"
		for m in $METAPACKAGES; do
			mpkgs_args=$(grep -Eo "METAPKG=.*" "./$arch/$m" | head -1 | tr '"' '\n' | grep "[a-z]")
			metapkg_page=$(curl -Ls --retry 5 --retry-max-time 120 "https://raw.githubusercontent.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io/refs/heads/main/apps/$m" 2>/dev/null)
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
echo "Done!"
