#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"

# Setup
_log "Running app version regex checks: $0"

# Extract and source _check_version_filters function from APP-MANAGER for regex testing (replace awk with $awk_cmd)
awk '/^_check_version_filters\(\) \{/,/^}/' /opt/am/APP-MANAGER | sed "s/awk/\$awk_cmd/g" > check_version_filters.sh
. "$(dirname "$0")/check_version_filters.sh"

# Test function against known app version examples (add as much as needed) using all versions of awk
for awk_cmd in awk gawk mawk original-awk goawk nawk busybox; do
	if command -v "$awk_cmd" >/dev/null 2>&1; then
		# Print which tool is used
		[ $awk_cmd = busybox ] && awk_cmd="busybox awk" # Busybox awk version is a subcommand
		printf "\nRegex testing with %s (%s):\n" "$awk_cmd" "$($awk_cmd --version 2>/dev/null | head -n 1)"

		# Test strings checked against expected version numbers
		echo "https://github.com/zk-org/zk/releases/download/v0.15.4/zk-v0.15.4-linux-amd64.tar.gz" | _check_version_filters | tee "$test_results"
		_check_count "0.15.4" 1 "$test_results"
		echo "https://github.com/cemu-project/Cemu/releases/download/v2.6/Cemu-2.6-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "2.6" 1 "$test_results"
		echo "https://github.com/pkgforge-dev/Cromite-AppImage/releases/download/v145.0.7632.120%402026-03-08_1772966182/Cromite-v145.0.7632.120-anylinux-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "145.0.7632.120" 1 "$test_results"
		echo "https://github.com/neovim/neovim/releases/download/v0.11.7/nvim-linux-x86_64.appimage" | _check_version_filters | tee "$test_results"
		_check_count "0.11.7" 1 "$test_results"
		echo "https://github.com/pkgforge-dev/Dolphin-emu-AppImage/releases/download/2603a%402026-05-01_1777638978/Dolphin-2603a-anylinux-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "2603a" 1 "$test_results"
		echo "https://github.com/AppImage/appimagetool/releases/download/1.9.1/appimagetool-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "1.9.1" 1 "$test_results"
		echo "https://github.com/pkgforge-dev/AppImageUpdate-deprecated/releases/download/a76b0ca08/appimageupdatetool%2Bvalidate-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "a76b0ca08" 1 "$test_results"
		echo "https://github.com/mean00/avidemux2/releases/download/2.8.1/avidemux_2.8.1-22.appImage" | _check_version_filters | tee "$test_results"
		_check_count "2.8.1-22" 1 "$test_results"
		echo "https://github.com/mean00/avidemux2/releases/download/2.8.1-1002%2026-04-11/release/avidemux_2.8.1-991.appImage" | _check_version_filters | tee "$test_results"
		_check_count "2.8.1-1002" 1 "$test_results"
		echo "https://github.com/Faster3ck/Converseen/releases/download/v0.15.2.4/Converseen-0.15.2.4-1-anylinux-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "0.15.2.4-1" 1 "$test_results"
		echo "https://github.com/ivan-hc/Hypnotix-appimage/releases/download/continuous/Hypnotix_5.6-2-archimage5.0-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "5.6-2" 1 "$test_results"
		echo "https://download.kde.org/stable/kdenlive/26.04/linux/kdenlive-26.04.1-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "26.04.1" 1 "$test_results"
		echo "https://gitlab.com/api/v4/projects/24386000/packages/generic/librewolf/151.0-1/LibreWolf.x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "151.0-1" 1 "$test_results"
		echo "https://github.com/ivan-hc/Poedit-appimage/releases/download/continuous/Poedit_3.8-4-archimage5.0-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "3.8-4" 1 "$test_results"
		echo "https://github.com/edisionnano/QDiskInfo/releases/download/0.4/QDiskInfo-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "0.4" 1 "$test_results"
		echo "https://github.com/abcfy2/qBittorrent-Enhanced-Edition/releases/download/v5.2.0.11.3/qBittorrent-Enhanced-Edition-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "5.2.0.11.3" 1 "$test_results"
		echo "https://github.com/ferraridamiano/ConverterNOW/releases/download/v4.6.0/converternow-linux-x86_64.tar.gz" | _check_version_filters | tee "$test_results"
		_check_count "4.6.0" 1 "$test_results"
		echo "https://ci.helio.fm/helio-3.17-x64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "3.17" 1 "$test_results"
		echo "https://codeberg.org/OpenRGB/OpenRGB/releases/download/release_candidate_1.0rc2/OpenRGB_1.0rc2_x86_64_0fca93e.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "1.0rc2" 1 "$test_results"
		echo "https://stable.eden-emu.dev/v0.2.0/Eden-Linux-v0.2.0-amd64-clang-pgo.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "0.2.0" 1 "$test_results"
		echo "https://github.com/RPCS3/rpcs3-binaries-linux/releases/download/build-41db06b53f906fbe2941552008ea8b468fa38482/rpcs3-v0.0.40-18914-41db06b5_linux64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "0.0.40-18914" 1 "$test_results"
		echo "https://github.com/project/releases/download/r5678.a3f2c1-42/app-r5678.a3f2c1-42.tar.gz" | _check_version_filters | tee "$test_results"
		_check_count "r5678.a3f2c1-42" 1 "$test_results"
		echo "https://github.com/myrepo/releases/download/r9012.d8e4b7-15/build-r9012.d8e4b7-15.zip" | _check_version_filters | tee "$test_results"
		_check_count "r9012.d8e4b7-15" 1 "$test_results"
		echo "https://github.com/developer/tool/releases/download/build-1234-7a8f9c2b1e5d%nightly/tool-1234-7a8f9c2b1e5d.tar" | _check_version_filters | tee "$test_results"
		_check_count "1234-7a8f9c2b1e5d" 1 "$test_results"
		echo "https://github.com/software/releases/download/567-3c4d5e6f7a8b%release-nightly/software-567-3c4d5e6f7a8b-x86_64.tar.gz" | _check_version_filters | tee "$test_results"
		_check_count "567-3c4d5e6f7a8b" 1 "$test_results"
		echo "https://github.com/project/releases/download/abc123def456/app-abc123def456.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "abc123def456" 1 "$test_results"
		echo "https://github.com/repo/releases/download/9f8e7d6c5b4a3/binary-9f8e7d6c5b4a3.xz" | _check_version_filters | tee "$test_results"
		_check_count "9f8e7d6c5b4a3" 1 "$test_results"
		echo "https://github.com/myapp/releases/download/v2.5/myapp-v2.5-linux.tar.gz" | _check_version_filters | tee "$test_results"
		_check_count "2.5" 1 "$test_results"
		echo "https://github.com/tool/releases/download/1.8/tool-1.8.tar.xz" | _check_version_filters | tee "$test_results"
		_check_count "1.8" 1 "$test_results"
		echo "https://github.com/project/releases/download/2024a/release-2024a.zip" | _check_version_filters | tee "$test_results"
		_check_count "2024a" 1 "$test_results"
		echo "https://github.com/software/releases/download/build1b3f/software-build1b3f.7z" | _check_version_filters | tee "$test_results"
		_check_count "1b3f" 1 "$test_results"
		echo "https://github.com/repo/releases/download/a1b2c3d4e5f6-release/app.tar.gz" | _check_version_filters | tee "$test_results"
		_check_count "a1b2c3d4e5f6" 1 "$test_results"
		echo "https://github.com/project/releases/download/nightly/binary_f7e6d5c4b3a29081.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "f7e6d5c4b3a29081" 1 "$test_results"
		echo "https://github.com/nothing_burger/releases/download/nightly/burger%f7c4b3a29081.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "f7c4b3a29081" 1 "$test_results"
		echo "https://github.com/knapsu/plex-media-player-appimage/releases/download/v2.58.1-ae73e074/Plex_Media_Player_2.58.1-ae73e074_x64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "2.58.1" 1 "$test_results"
		echo "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-4.13.2.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "4.13.2" 1 "$test_results"
		echo "https://github.com/opensteno/plover/releases/download/v5.3.0/plover-5.3.0-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "5.3.0" 1 "$test_results"
		echo "https://github.com/nuttyartist/plume-public/releases/download/v0.9.9/Plume_0.9.9-Qt6.7.0-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "0.9.9" 1 "$test_results"
		echo "https://github.com/pkgforge-dev/Plus42-AppImage/releases/download/1.3.13-1%402026-04-22_1776856410/Plus42-1.3.13-100-anylinux-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "1.3.13-100" 1 "$test_results"
		echo "https://github.com/xyproto/png2svg/releases/download/v1.7.0/png2svg-1.7.0-linux.tar.xz" | _check_version_filters | tee "$test_results"
		_check_count "1.7.0" 1 "$test_results"
		echo "https://github.com/containers/podman/releases/download/v5.8.2/podman-remote-static-linux_amd64.tar.gz" | _check_version_filters | tee "$test_results"
		_check_count "5.8.2" 1 "$test_results"
		echo "https://github.com/pkgforge-dev/Polybar-AppImage/releases/download/3.7.2.r29.gf99e0b1c-1%402026-04-27_1777281615/polybar-3.7.2.r29.gf99e0b1c-1-anylinux-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "3.7.2.r29" 1 "$test_results"
		echo "https://gitlab.com/cubocore/packages/-/raw/main/appimages/v3.0.0LTS/CoreShot-d5f6110-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "3.0.0" 1 "$test_results"
		echo "https://github.com/pkgforge-dev/qarma-AppImage/releases/download/r1.d3730ad-1%402026-05-22_1779458497/qarma-r1.d3730ad-1-anylinux-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "r1.d3730ad-1" 1 "$test_results"

		# Test strings checked against nothing versions
		echo "https://github.com/pragtical1231/pragtical9223/releases/download/rolling/Pragtical-rolling-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "-" 1 "$test_results"
		echo "https://github.com/Lateralus138/colorstatic-bash/releases/download/Continuous/colorstatic-aarch64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "-" 1 "$test_results"
		echo "https://github.com/burger/nothing-burger/releases/download/rolling-i686/fancy-nothing-burger-amd64-i386.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "-" 1 "$test_results"
	fi
done

# Pass the test
_pass

