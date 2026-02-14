#!/bin/sh
# This script is ment to split installation scripts by sources
# Run this script from the "tools" directory of your fork of AM
# The SOURCES directory will be created and compiled at root of the repo

# Reset SOURCES directory
rm -Rf ../SOURCES/*

DIRS=$(find ../programs -type d | grep "/" | sed 's:.*/::' | grep -v "programs$")
for arch in $DIRS; do
	SOURCES_DIR="../SOURCES/$arch"
	for a in ../programs/"$arch"/*; do
		# Applications hosted on github.com, using github APIs
		if grep -q "version=.*api.github.com" "$a"; then
			# Determine if they need an alternative way to download the artifacts
			if ! grep -q "wget \"\$version\"" "$a"; then
				mkdir -p "$SOURCES_DIR"/github-custom
				cp -r "$a" "$SOURCES_DIR"/github-custom/
			else
				mkdir -p "$SOURCES_DIR"/github
				cp -r "$a" "$SOURCES_DIR"/github/
			fi
		# Applications hosted on sourceforge
		elif grep -q "version=.*sourceforge" "$a"; then
			mkdir -p "$SOURCES_DIR"/sourceforge
			cp -r "$a" "$SOURCES_DIR"/sourceforge/
		# Applications hosted on codeberg
		elif grep -q "version=.*codeberg" "$a"; then
			mkdir -p "$SOURCES_DIR"/codeberg
			cp -r "$a" "$SOURCES_DIR"/codeberg/
		# Applications hosted on gitlab
		elif grep -q "version=.*gitlab.*v4" "$a"; then
			mkdir -p "$SOURCES_DIR"/gitlab
			cp -r "$a" "$SOURCES_DIR"/gitlab/
		# Applications hosted on kde hosts
		elif grep -q "version=.*kde.org" "$a"; then
			mkdir -p "$SOURCES_DIR"/kde
			cp -r "$a" "$SOURCES_DIR"/kde/
		# Applications are Firefox WebApps
		elif echo "$a" | grep -q -- "ffwa-"; then
			mkdir -p "$SOURCES_DIR"/ffwa
			cp -r "$a" "$SOURCES_DIR"/ffwa/
		# Applications are Mozilla products or derivatives of the latter
		elif echo "$a" | grep -q "firefox\|thunderbird\|tor-browser\|zotero"; then
			mkdir -p "$SOURCES_DIR"/mozilla
			cp -r "$a" "$SOURCES_DIR"/mozilla/
		# Applications hosted on custom sources (the more problematic ones)
		else
			# Determine if the app source is taken from AUR
			if grep -q "version=.*https://raw.githubusercontent.com/archlinux/aur/refs" "$a"; then
				mkdir -p "$SOURCES_DIR"/custom-aur
				cp -r "$a" "$SOURCES_DIR"/custom-aur/
			# Determine if the app require more steps to be downloaded
			elif ! grep -q "wget \"\$version\"" "$a"; then
				mkdir -p "$SOURCES_DIR"/custom-verbose
				cp -r "$a" "$SOURCES_DIR"/custom-verbose/
			# Determine if the app have multiple choose
			elif grep -q "^RELEASE=" "$a"; then
				mkdir -p "$SOURCES_DIR"/custom-multichoose
				cp -r "$a" "$SOURCES_DIR"/custom-multichoose/
			else
				mkdir -p "$SOURCES_DIR"/custom-standard
				cp -r "$a" "$SOURCES_DIR"/custom-standard/
			fi
		fi
	done
done
