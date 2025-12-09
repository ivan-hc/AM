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
		# # Applications hosted on custom sources (the more problematic ones)
		else
			mkdir -p "$SOURCES_DIR"/custom
			cp -r "$a" "$SOURCES_DIR"/custom/
		fi
	done
done