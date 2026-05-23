#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"

# Setup
_log "Running app version regex checks: $0"

# Extract and source _check_version_filters function from APP-MANAGER for regex testing
awk '/^_check_version_filters\(\) \{/,/^}/' /opt/am/APP-MANAGER > check_version_filters.sh
. "$(dirname "$0")/check_version_filters.sh"

# Test all awk versions (mawk/gawk/original-awk)
for awk_cmd in awk gawk mawk original-awk goawk; do
	alias awk='$awk_cmd'
	if command -v "$awk_cmd" >/dev/null 2>&1; then
		# Print which tool is used
		printf "\nRegex testing with %s (%s):\n" "$awk_cmd" "$($awk_cmd --version | head -n 1)"

		# Test function against known app version examples (add as much as needed)
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

		echo "https://github.com/mean00/avidemux2/releases/download/2.8.1/avidemux_2.8.1.appImage" | _check_version_filters | tee "$test_results"
		_check_count "2.8.1" 1 "$test_results"

		echo "https://github.com/Faster3ck/Converseen/releases/download/v0.15.2.4/Converseen-0.15.2.4-1-anylinux-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "0.15.2.4" 1 "$test_results"

		echo "https://github.com/ivan-hc/Hypnotix-appimage/releases/download/continuous/Hypnotix_5.6-2-archimage5.0-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "5.6-2" 1 "$test_results"

		echo "https://download.kde.org/stable/kdenlive/26.04/linux/kdenlive-26.04.1-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "26.04" 1 "$test_results"

		echo "https://gitlab.com/api/v4/projects/24386000/packages/generic/librewolf/151.0-1/LibreWolf.x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "151.0-1" 1 "$test_results"

		echo "https://github.com/ivan-hc/Poedit-appimage/releases/download/continuous/Poedit_3.8-4-archimage5.0-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "3.8-4" 1 "$test_results"

		echo "https://github.com/edisionnano/QDiskInfo/releases/download/0.4/QDiskInfo-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "0.4" 1 "$test_results"

		echo "https://github.com/abcfy2/qBittorrent-Enhanced-Edition/releases/download/v5.2.0.11.3/qBittorrent-Enhanced-Edition-x86_64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "5.2.0.11.3" 1 "$test_results"

		echo "github.com/ferraridamiano/ConverterNOW/releases/download/v4.6.0/converternow-linux-x86_64.tar.gz" | _check_version_filters | tee "$test_results"
		_check_count "4.6.0" 1 "$test_results"

		echo "https://ci.helio.fm/helio-3.17-x64.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "3.17" 1 "$test_results"

		echo "https://codeberg.org/OpenRGB/OpenRGB/releases/download/release_candidate_1.0rc2/OpenRGB_1.0rc2_x86_64_0fca93e.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "1.0rc" 1 "$test_results"

		echo "https://stable.eden-emu.dev/v0.2.0/Eden-Linux-v0.2.0-amd64-clang-pgo.AppImage" | _check_version_filters | tee "$test_results"
		_check_count "0.2.0" 1 "$test_results"
    fi
done

# Pass the test
_pass

