#!/usr/bin/env bash

obsolescence_threshold=$(date -u -d "1 years ago" +"%Y")

_archived_list() {
	user_repo=$(grep "^SITE=" "$arg" | head -1 | awk -F'"' '/^SITE=/{print $2}')
	if curl -s "https://api.gh.pkgforge.dev/repos/$user_repo" | grep -q '"archived".* true,'; then
		echo "$arg" | sed s:.*/:: >> archived-list.tmp
	fi
}

_obsolete_list() {
	user_repo=$(grep "^SITE=" "$arg" | head -1 | awk -F'"' '/^SITE=/{print $2}')
	date=$(curl -s "https://api.gh.pkgforge.dev/repos/$user_repo/releases" | grep -oP '"updated_at": "\K\d{4}' | head -1)
	if [ -n "$date" ] && echo "$date" | grep -qE '^[0-9]{4}$' && [ "$date" -lt "$obsolescence_threshold" ]; then
		echo "$arg $date" | sed s:.*/:: >> obsolete-list.tmp
	fi
	date=""
}

# Determine archived repositories
echo "Determine archived repositories"
for arg in x86_64/*; do
	if grep -q "^version=.*api.github.com" "$arg" && grep -q "^SITE=" "$arg"; then
		_archived_list &
	fi
done
wait

sort -u archived-list.tmp > archived-apps
rm -f archived-list.tmp

# Determine repositories no more updated in the last years
echo "Determine repositories no more updated in the last years"
for arg in x86_64/*; do
	if grep -q "^version=.*api.github.com.*/releases" "$arg" && grep -q "^SITE=" "$arg"; then
		_obsolete_list &
	fi
done
wait

sort -u obsolete-list.tmp > obsolete-apps
rm -f obsolete-list.tmp
