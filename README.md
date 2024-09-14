# "AM" Application Manager
### Database & solutions for all AppImages and portable apps for GNU/Linux!

<div align="center">

| <img src="https://raw.githubusercontent.com/ivan-hc/AM/main/sample/sandbox.gif"> | <img src="https://raw.githubusercontent.com/ivan-hc/AM/main/sample/list.gif"> | <img src="https://raw.githubusercontent.com/ivan-hc/AM/main/sample/about.gif"> |
| - | - | - |
| *sandbox AppImages* | *list available apps* | *info about the apps* |
| <img src="https://raw.githubusercontent.com/ivan-hc/AM/main/sample/install.gif"> | <img src="https://raw.githubusercontent.com/ivan-hc/AM/main/sample/query.gif"> | <img src="https://raw.githubusercontent.com/ivan-hc/AM/main/sample/files.gif"> |
| *install applications* | *query lists using keywords* | *show the installed apps* |
| <img src="https://raw.githubusercontent.com/ivan-hc/AM/main/sample/backup-overwrite.gif"> | <img src="https://raw.githubusercontent.com/ivan-hc/AM/main/sample/update.gif"> | <img src="https://raw.githubusercontent.com/ivan-hc/AM/main/sample/nolibfuse.gif"> |
| *create and restore snapshots* | *update everything* | *get rid of libfuse2* |

</div>

"AM"/"AppMan" is a set of scripts and modules for installing, updating, and managing AppImage packages and other portable formats, in the same way that APT manages DEBs packages, DNF the RPMs, and so on... using a large database of Shell scripts inspired by the Arch User Repository, each dedicated to an app or set of applications.

The engine of "AM"/"AppMan" is the "APP-MANAGER" script which, depending on how you install or rename it, allows you to install apps system-wide (for a single system administrator) or locally (for each user).

"AM"/"AppMan" aims to be the default package manager for all AppImage packages, giving them a home to stay.

You can consult the entire **list of managed apps** at [**portable-linux-apps.github.io/apps**](https://portable-linux-apps.github.io/apps).

------------------------------------------------------------------------
# IMPORTANT!

"AM"/"AppMan" is just a tool to provide applications easily and quickly and is only responsible for integrating the AppImages into the system and installing the various programs available, respecting the following order (refer to the option "`-d`" to download the installation script without installing it):
1. creation of the base directories and the removal script
2. download of the package
3. creation of the version file and the update script
4. possibly, extraction of the icons and .desktop files*

*NOTE, aside from the references to downloading and updating apps (the "$version" variable), the **installation scripts are mostly the same**, especially for AppImages, and there may be slight variations in the final processes depending if the .desktop file has problems when it is extracted from the package and/or it fail in being added to the menu. If there are problems with updates or missing launchers, open an "[issue](https://github.com/ivan-hc/AM/issues)" and I'll fix it ASAP.

That said, **any malfunction related to individual applications is the responsibility of the related developer or packager**.

Refer to the option "`-a`" to know the sources of each program listed here, so you can contact them to report the bug.

------------------------------------------------------------------------
### Main Index
------------------------------------------------------------------------
[Differences between "AM" and "AppMan"](#differences-between-am-and-appman)
- [Ownership](#ownership)
- [About "sudo" usage](#about-sudo-usage)
- [How apps are installed](#how-apps-are-installed)
- [How to use "AM" in non-privileged mode, like "AppMan"](#how-to-use-am-in-non-privileged-mode-like-appman)

[What programs can be installed](#what-programs-can-be-installed)

[How to update all programs, for real](#how-to-update-all-programs-for-real)

[Installation](#installation)
- [How to install "AM"](#how-to-install-am)
- [How to install "AppMan"](#how-to-install-appman)

[Uninstall](#uninstall)

[Usage (all the available options)](#usage)

[Guides and tutorials](#guides-and-tutorials)
- [Install applications](#install-applications)
- [Install only AppImages](#install-only-appimages)
- [Install AppImages not listed in this database but available in other github repos](#install-appimages-not-listed-in-this-database-but-available-in-other-github-repos)
- [List the installed applications](#list-the-installed-applications)
- [List and query all the applications available on the database](#list-and-query-all-the-applications-available-on-the-database)
- [Update all](#update-all)
- [Backup and restore installed apps using snapshots](#backup-and-restore-installed-apps-using-snapshots)
- [Remove one or more applications](#remove-one-or-more-applications)
- [Convert Type2 AppImages requiring libfuse2 to New Generation AppImages](#convert-type2-appimages-requiring-libfuse2-to-new-generation-appimages)
- [Integrate local AppImages into the menu by dragging and dropping them](#integrate-local-appimages-into-the-menu-by-dragging-and-dropping-them)
  - [How to create a launcher for a local AppImage](#how-to-create-a-launcher-for-a-local-appimage)
  - [How to remove the orphan launchers](#how-to-remove-the-orphan-launchers)
  - [AppImages from external media](#appimages-from-external-media)
- [How to use "AM" in non-privileged mode, like "AppMan"](#how-to-use-am-in-non-privileged-mode-like-appman)
- [Sandbox an AppImage](#sandbox-an-appimage)
  - [How to enable a sandbox](#how-to-enable-a-sandbox)
  - [How to disable a sandbox](#how-to-disable-a-sandbox)
  - [Sandboxing example](#sandboxing-example)
  - [About Aisap sandboxing](#about-aisap-sandboxing)
- [How to enable bash completion](#how-to-enable-bash-completion)
- [How to update or remove apps manually](#how-to-update-or-remove-apps-manually)
- [Downgrade an installed app to a previous version](#downgrade-an-installed-app-to-a-previous-version)
- [Create and test your own installation script](#create-and-test-your-own-installation-script)
  - [Option Zero: "AppImages"](#option-zero-appimages)
  - [Option One: "build AppImages on-the-fly"](#option-one-build-appimages-on-the-fly)
  - [Option Two: "Archives and other programs"](#option-two-archives-and-other-programs)
  - [Option Three: "Firefox profiles"](#option-three-firefox-profiles)
  - [How an installation script works](#how-an-installation-script-works)
  - [How to test an installation script](#how-to-test-an-installation-script)
- [Third-party databases for applications (NeoDB)](#third-party-databases-for-applications-neodb)

[Troubleshooting](#troubleshooting)
- [An application does not work, is old and unsupported](#an-application-does-not-work-is-old-and-unsupported)
- [Cannot download or update an application](#cannot-download-or-update-an-application)
- [Cannot mount and run AppImages](#cannot-mount-and-run-appimages)
- [Spyware, malware and dangerous software](#spyware-malware-and-dangerous-software)
- [Stop AppImage prompt to create its own launcher, desktop integration and doubled launchers](#stop-appimage-prompt-to-create-its-own-launcher-desktop-integration-and-doubled-launchers)
- [The script points to "releases" instead of downloading the latest stable](#the-script-points-to-releases-instead-of-downloading-the-latest-stable)
- [Wrong download link](#wrong-download-link)

[Related projects](#related-projects)

------------------------------------------------------------------------
# Differences between "AM" and "AppMan"
"AM" and "AppMan" differ in how they are installed, placed and renamed in the system and how/where they install apps:
- "**AM**" is installed system-wide (requires `sudo` or `doas`) in `/opt/am/` as "**APP-MANAGER**", with a symlink named "`am`" in `/usr/local/bin`.
- "**AppMan**" is portable, you need just to rename the "APP-MANAGER" script as "`appman`" and put it wherewer you want. I recommend to place it in `$HOME/.local/bin` to be used in $PATH, to be managed from other tools (see below).

Both can be updated using "[Topgrade](https://github.com/topgrade-rs/topgrade)".

------------------------------------------------------------------------

### Ownership
- "**AM**" is owned by the user that have installed it, since other users have not read/write permissions in "/opt/am";
- "**AppMan**" is for all users, since it works locally, everyone can have its own apps and configurations.

------------------------------------------------------------------------

### About "sudo" usage
- "AppMan" can request the root password only in the very rare case in which you want to install a library;
- "AM" requires the root password only to install, remove apps, enable a sandbox for an AppImage.

All options cannot be executed with "`sudo`"/"`doas`".

------------------------------------------------------------------------

### How apps are installed

------------------------------------------------------------------------

- "**AM**" installs apps system wide, in `/opt` (see [Linux Standard Base](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s13.html)), using the following structure:
```
/opt/$PROGRAM/
/opt/$PROGRAM/$PROGRAM
/opt/$PROGRAM/AM-updater
/opt/$PROGRAM/remove
/opt/$PROGRAM/icons/$ICON-NAME
/usr/local/bin/$PROGRAM
/usr/local/share/applications/$PROGRAM-AM.desktop
```

------------------------------------------------------------------------

- "**AppMan**" is more flexible, since it asks you where to install the apps. For example, suppose you want install everything in "Applicazioni" (the italian of "applications") and in your $HOME directory, this is the structure of what an installation scripts installs with "AppMan" instead:
```
~/Applicazioni/$PROGRAM/
~/Applicazioni/$PROGRAM/$PROGRAM
~/Applicazioni/$PROGRAM/AM-updater
~/Applicazioni/$PROGRAM/remove
~/Applicazioni/$PROGRAM/icons/$ICON-NAME
~/.local/bin/$PROGRAM
~/.local/share/applications/$PROGRAM-AM.desktop
```

The configuration file for AppMan is in `~/.config/appman` and contains the path you indicated at first startup. Changing its contents will result in changing the paths for each subsequent operation carried out with "AppMan", the apps and modules stored in the old path will not be manageable.

At first startup you can indicate any directory or subdirectory you want.

------------------------------------------------------------------------

### How to use "AM" in non-privileged mode, like "AppMan"
As already mentioned above, at "[Ownership](#ownership)" the user who installed "AM" is the sole owner, having write permissions for both /opt/am and for all installed apps.

However, every user of the same system is allowed to use the option `--user` or `appman`, to use "AM" as "AppMan" and to install apps locally and withour root privileges:
```
am --user
```
To switch "AM" back to "AM" from "AppMan Mode", use the always suggested option `--system`:
```
am --system
```
To perform a test and see if you are in "AppMan Mode" or not, run for example the command `am -f` to see the list of the installed apps.

In this video I'll install LXtask locally:

https://github.com/ivan-hc/AM/assets/88724353/65b27cf6-edc5-4a4c-b2f9-42e8623dc76f

NOTE: non-privileged users can update their own local applications and modules, but cannot update /opt/am/APP-MANAGER.

It is therefore suggested to use pure "AppMan" instead of the "AppMan Mode" of "AM".

------------------------------------------------------------------------

| [Install "AM"/"AppMan"](#installation) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------
# What programs can be installed
"AM"/"AppMan" installs, removes, updates and manages only standalone programs, ie those programs that can be run from a single directory in which they are contained. The database aims to be a reference point where you can download all the AppImage packages scattered around the web, otherwise unobtainable, as you would expect from any package manager, through specific installation scripts for each application, as happens with the AUR PKGBUILDs, on Arch Linux. You can see all of them [here](https://github.com/ivan-hc/AM/tree/main/programs), divided by architecture.

NOTE that currently my work focuses on applications for [x86_64](https://github.com/ivan-hc/AM/tree/main/programs/x86_64) architecture, but it is possible to extend "AM" to all other available architectures. If you are interested, you can deliberately join this project to improve the available lists.

1. **PROGRAMS**, they are taken:
- from official sources (see Firefox, Thunderbird, Blender, NodeJS, Chromium Latest, Platform Tools...);
- extracted from official .deb/tar/zip packages;
- from the repositories and official sites of individual developers.

2. **APPIMAGES**, they are taken:
- from official sources (if the upstream developers provide them);
- from AppImage recipes to be compiled on-the-fly with [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit);
- from unofficial third-party developers, but only if an official release is not available.

3. **FIREFOX PROFILES** to run as webapps, the ones with suffix "ffwa-" in the apps list.

4. **THIRD-PARTY LIBRARIES** (see [here](https://github.com/ivan-hc/AM/blob/main/libraries/libs-list)) if they are not provided in your distribution's repositories. These are to be installed in truly exceptional cases.

You can consult basic information, links to sites and sources used through the related command `am -a $PROGRAM` or `appman -a $PROGRAM`, or visit [**portable-linux-apps.github.io/apps**](https://portable-linux-apps.github.io/apps).

------------------------------------------------------------------------

| [Back to "Main Index"](#main-index) |
| - |

------------------------------------------------------------------------
# How to update all programs, for real
One of the reasons why many users hate Appimages is because they cannot be updated. Or at least not all.

This project was born to dispel this myth and to solve the problem. And the solution is much more trivial than you expect.

There are several methods to update apps, here are the most common ones, in order of priority:
- the "comparison between versions" is the most widespread in the database, the version of the app installed is compared with the one present at the source, be it an official site or another site that tracks it;
- if an AppImage package has a .zsync file, that will be used to download binary deltas (especially useful with large files, but not very popular among developers);
- some portable apps are self-updatable (see Firefox and Thunderbird);
- if an app or script is extremely small (a few kilobytes), it is downloaded directly from scratch;
- in rare cases, if a file .zsync is broken, we use [appimageupdatetool](https://github.com/AppImage/AppImageUpdate);
- in some cases, the apps have a fixed version, both due to the developers' choices to abandon a portable package in favor of other more common platforms, and because a software is no longer developed.

NOTE, fixed versions will be listed with their build number (e.g. $PROGRAM-1.1.1) or will be added only upon request.

### How to update all installed apps
Option `-u` or `update` updates all the installed apps and keeps "AM"/"AppMan" in sync with the latest version and all latest bug fixes.

https://github.com/ivan-hc/AM/assets/88724353/f93ca782-2fc6-45a0-a3f2-1fba297a92bf

1. To update only the programs, use `am -u --apps` / `appman -u --apps`
2. To update just one program, use `am -u $PROGRAM` / `appman -u $PROGRAM`
3. To update all the programs and "AM"/"AppMan" itself, just run the command`am -u` / `appman -u`
4. To update only "AM"/"AppMan" and the modules use the option `-s` instead, `am -s` / `appman -s`

NOTE, non-privileged users using "AM" in "AppMan Mode" cannot update /opt/am/APP-MANAGER (points 3 and 4). See "[How to use AM in non-privileged mode, like AppMan](#how-to-use-am-in-non-privileged-mode-like-appman)".

### How to update everything using "Topgrade"
Keeping your system up to date usually involves invoking multiple package managers. This results in big, non-portable shell one-liners saved in your shell. To remedy this, Topgrade detects which tools you use and runs the appropriate commands to update them.

Install the "topgrade" package using the command
```
am -i topgrade
```
or
```
appman -i topgrade
```

Visit [github.com/topgrade-rs/topgrade](https://github.com/topgrade-rs/topgrade) to learn more.

NOTE, "AppMan" users must install `appman` in ~/.local/bin to allow updates via Topgrade. See "[How to install AppMan](#how-to-install-appman)".

------------------------------------------------------------------------

| [Back to "Main Index"](#main-index) |
| - |

------------------------------------------------------------------------
# Installation
This section explains how to install "AM" or "AppMan".

If you don't know the difference, please read "[Differences between "AM" and "AppMan"](#differences-between-am-and-appman)" first.

You can choose to continue reading and see the installation methods in detail (jump to "[Core dependences](#core-dependences)"), or you can choose to use the common installer for "AM" and "AppMan", named "[AM-INSTALLER](https://github.com/ivan-hc/AM/blob/main/AM-INSTALLER)", by downloading the script and making it executable, like this:
```
wget -q https://raw.githubusercontent.com/ivan-hc/AM/main/AM-INSTALLER
chmod a+x ./AM-INSTALLER
./AM-INSTALLER
```
Type "1" to install "AM" (requires "sudo"/"doas" password), "2" to install "AppMan". Any other key will abort the installation.

| ![AM-INSTALLER](https://github.com/user-attachments/assets/82b21979-e99d-4bee-b466-716bac1e7e45) |
| - |

This "[AM-INSTALLER](https://github.com/ivan-hc/AM/blob/main/AM-INSTALLER)" script acts as a "launcher" to speed up the processes available in the guides "[How to install "AM"](#how-to-install-am)" and "[How to install "AppMan"](#how-to-install-appman)". "AppMan" will be installed in ~/.local/bin and the script will take care of enabling it in "$PATH".

------------------------------------------------------------------------
#### Core dependences
Below are the **essential system dependencies** that you must install before proceeding:
- "`coreutils`" (contains "`cat`", "`chmod`", "`chown`"...);
- "`curl`", to check URLs;
- "`grep`", to check files;
- "`sed`", to edit/adapt installed files;
- "`wget`" to download all programs and update "AM"/"AppMan" itself.

#### Dependency only for "AM"
- "`sudo`" or "`doas`", required by "AM" to install/remove programs, sandbox AppImages and enable/disable bash-completion.

#### Extra dependences (recommended)
The following are optional dependencies that some programs may require:
- "`binutils`", contains a series of basic commands, including "`ar`" which extracts .deb packages;
- "`unzip`", to extract .zip packages;
- "`tar`", to extract .tar* packages;
- "`zsync`", about 10% of AppImages depend on this to be updated.

### Proceede

- [How to install "AM"](#how-to-install-am)
- [How to install "AppMan"](#how-to-install-appman)


## How to install "AM"
"**AM**" is ment to be installed at system level to manage apps.

The script "[INSTALL](https://github.com/ivan-hc/AM/blob/main/INSTALL)" is the one that take care of this.

https://github.com/user-attachments/assets/857d28d4-d2ae-42a0-9fe2-95fd62d48d65

#### Using "Wget"
```
wget https://raw.githubusercontent.com/ivan-hc/AM/main/INSTALL
chmod a+x ./INSTALL
sudo ./INSTALL
```
or directly
```
wget https://raw.githubusercontent.com/ivan-hc/AM/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL
```

#### Using "GIT"
```
git clone https://github.com/ivan-hc/AM.git
cd AM
chmod a+x INSTALL
sudo ./INSTALL
```

### Structure of the "AM" installation
In both cases, the "INSTALL" script will create:
- the script "/opt/am/APP-MANAGER"
- the script "/opt/am/remove" (to remove "AM" using the command `am -R am`)
- the directory "/opt/am/modules" (containing the .am modules for the non-core options)
- the symlink "/usr/local/bin/am" for "/opt/am/APP-MANAGER"

all processes will been executed in $HOME/.cache/am, while application lists, keywords to use in bash/zsh completion and other files (for third party repos, betatesting, etcetera...) will be saved and updated in $HOME/.local/share/AM to be shared with "AppMan", if installed or you use "AM" in "AppMan Mode".

NOTE, if you don't feel comfortable having to always use root permissions, the installation method for "AppMan" is totally different. If you are interested, go [to the next paragraph](#how-to-install-appman), else [Back to "Main Index"](#main-index) or jump to "[Usage (all the available options)](#usage)".

------------------------------------------------------------------------
## How to install "AppMan"
"**AppMan**" can be used in different places, being it portable.

However, to be easily used its recommended to place it in your local "$PATH", in `~/.local/bin`.

#### Use "AppMan" in "$PATH"
To do so, you must first enable that "$PATH":
- add `export PATH="$PATH:$HOME/.local/bin"` in the ` ~/.bashrc`
- create the directory `~/.local/bin` if it is not available

To do all this quickly, simply copy/paste the following command:
```
mkdir -p ~/.local/bin && echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc && wget https://raw.githubusercontent.com/ivan-hc/AM/main/APP-MANAGER -O ~/.local/bin/appman && chmod a+x ~/.local/bin/appman
```
#### Use "AppMan" in "Portable Mode"
"AppMan" can run in any directory you download it, copy/paste the following command to download "APP-MANAGER", rename it to `appman` and make it executable:
```
wget https://raw.githubusercontent.com/ivan-hc/AM/main/APP-MANAGER -O appman && chmod a+x ./appman
```

### Structure of the "AppMan" installation
Unlike "AM" which needs to be placed in specific locations, "AppMan" is portable. The modules and directories will be placed in the directory you chose:
- the script "appman" is wherever you want
- the directory "/path/to/your/custom/directory/modules" (containing the .am modules for the non-core options)
- the configuration file "$HOME/.config/appman/appman-config" (the only fixed directory)

all processes will been executed in $HOME/.cache/appman, while application lists, keywords to use in bash/zsh completion and other files (for third party repos, betatesting, etcetera...) will be saved and updated in $HOME/.local/share/AM to be shared with "AM", if installed.

------------------------------------------------------------------------

| [Back to "Main Index"](#main-index) |
| - |

------------------------------------------------------------------------
# Uninstall
- To uninstall "AM" just run the command `am -R am`
- To uninstall "AppMan" just remove it and the directory `$HOME/.config/appman`

Note, before you remove your CLI, use the option `-R` to remove the apps installed using the following syntax:
```
am -R {PROGRAM1} {PROGRAM2} {PROGRAM3}...
```
or
```
appman -R {PROGRAM1} {PROGRAM2} {PROGRAM3}...
```

to have a list of the installed programs use the option `-f` or `files` (syntax `am -f` or `appman -f`).

See also "[How to update or remove apps manually](#how-to-update-or-remove-apps-manually)".

------------------------------------------------------------------------

| [Back to "Main Index"](#main-index) |
| - |

------------------------------------------------------------------------
# USAGE
```
 am {OPTION}

 am {OPTION} {ARGUMENT}
```

<details>
  <summary>Click here to see the full list of options</summary>

 ___________________________________________________________________________

## OPTIONS:
 
### `about, -a`

		-a {PROGRAM}

Description: Shows more info about one or more apps.

### `apikey`

		apikey {Github Token}
		apikey delete

Description: Accede to github APIs using your personal access tokens. The file named "ghapikey.txt" will be saved in ~/.local/share/AM. Use "del" to remove it.

### `backup, -b`

		-b {PROGRAM}

Description: Create a snapshot of the current version of an installed program.

### `clean, -c`

		-c

Removes all the unnecessary files and folders.

### `config, -C, --config`

		-C {PROGRAM}

Description: Set a dedicated $XDG_CONFIG_HOME for one or more AppImages.

### `downgrade, --rollback`

		--rollback {PROGRAM}

Description: Download an older or specific app version.

### `download, -d`

		-d {PROGRAM}
		-d --convert {PROGRAM}

Description: Download one or more installation scripts to your desktop or convert them to local installers for "AppMan" (the latter must be present).

### `extra, -e`

		-e user/project {APPNAME}
		-e user/project {APPNAME} {KEYWORD}

Description: Install AppImages from github.com, outside the database. This allows you to install, update and manage them all like the others. Where "user/project" can be the whole URL to the github repository, give a name to the program so that it can be used from the command line. Optionally, add an "univoque" keyword if multiple AppImages are listed.

### `files, -f`

		-f
		-f --byname
		-f --less

Description: Shows the list of all installed programs, with sizes. By default apps are sorted by size, use "--byname" to sort by name. With the option "--less" it shows only the number of installed apps.

### `help -h`

		-h

Description: Prints this message.

### `home, -H, --home`

		-H {PROGRAM}

Description: Set a dedicated $HOME directory for one or more AppImages.

### `icons, --icons`
 
                --icons {PROGRAM}
                --icons --all
 
Description: Allow installed apps to use system icon themes. You can specify the name of the apps to change or use the "--all" flag to change all of them at once. This will remove the icon path from the .desktop file and add the symbolic link of all available icons in the $HOME/.local/share/icons/hicolor/scalable/apps directory.

### `install, -i`

		-i {PROGRAM}
		-i --debug {PROGRAM}
		-i --force-latest {PROGRAM}

Description: Install one or more programs or libraries from the list. With the "--debug" option you can see log messages to debug the script. For more details on "--force-latest", see the dedicated option, below.

### `install-appimage, -ia`
 
                -ia {PROGRAM}
                -ia --debug {PROGRAM}
                -ia --force-latest {PROGRAM}
 
 Description: Same as "install" (see above) but for AppImages only.


### `lock`

		lock {PROGRAM}

Description: Prevent an application being updated, if it has an"AM-updater" script.

### `list, -l`

		-l
		-l --appimages

Description: Shows the list of all the apps available, or just the AppImages.

### `newrepo, neodb`

		newrepo add {URL}\{PATH}
		newrepo select
		newrepo on\off
		newrepo purge
		newrepo info

Description: Set a new default repo, use "add" to append the path to a local directory or an online URL, then use "select" to use it by default, a message will warn you about the usage of this repo instead of the default one. Use "on"/"off" to enable/disable it. Use "purge" to remove all 3rd party repos. Use "info" to see the source from where installation scripts and lists are taken.

### `nolibfuse`

		nolibfuse {PROGRAM}

Description: Convert old AppImages and get rid of "libfuse2" dependence.

### `overwrite, -o`

		-o {PROGRAM}

Description: Overwrite apps with snapshots saved previously (see "-b").

### `query, -q`

		-q {KEYWORD}
		-q --appimages {KEYWORD}
		-q --pkg {PROGRAM1} {PROGRAM2}

Description: Search for keywords in the list of available applications, add the "--appimages" option to list only the AppImages or add "--pkg" to list multiple programs at once.

### `remove, -r`

		-r {PROGRAM}

Description: Removes one or more apps, requires confirmation.

### `-R`

		-R {PROGRAM}

Description: Removes one or more apps without asking.

### `sandbox, --sandbox`

		sandbox {PROGRAM}

Description: Run an AppImage in a sandbox using Aisap.

### `sync, -s`

		-s

Description: Updates this script to the latest version hosted.

### `template, -t`

		-t {PROGRAM}

Description: Generate a custom installation script.

### `unlock`

		unlock {PROGRAM}

Description: Unlock updates for the selected program (nulls "lock").

### `update, -u, -U`

		-u
		-u --apps
		-u {PROGRAM}

Description: Update everything. Add "--apps" to update oly the apps or write only the apps you want to update by adding their names.

### `version, -v`

		-v

Description: Shows the version.

### `--devmode-disable`

		--devmode-disable

Description: Undo "--devmode-enable" (see below).

### `--devmode-enable`

		--devmode-enable

Description: Use the development branch (at your own risk).

### `--disable-sandbox`

		--disable-sandbox {PROGRAM}

Description: Disable the sandbox for the selected app.

### `--force-latest`

		--force-latest {PROGRAM}

Description: Downgrades an installed app from pre-release to "latest".

### `--launcher`

		--launcher /path/to/${APPIMAGE}

Description: Drag/drop one or more AppImages in the terminal and embed them in the apps menu and customize a command to use from the CLI.

### `--system`

		--system

Description: Switch "AM" back to "AM" from "AppMan Mode" (see "--user").

### `--user, appman`

		--user

Description: Made "AM" run in "AppMan Mode", locally, useful for unprivileged users. This option only works with "AM".

 __________________________________________________________________________

</details>

------------------------------------------------------------------------

| [Install "AM"/"AppMan"](#installation) | [Back to "Main Index"](#main-index) |
| - | - |

-----------------------------------------------------------------------------

# Guides and tutorials
This section is committed to giving small demonstrations of each available option, with videos:

  - [Install applications](#install-applications)
  - [Install only AppImages](#install-only-appimages)
  - [Install AppImages not listed in this database but available in other github repos](#install-appimages-not-listed-in-this-database-but-available-in-other-github-repos)
  - [List the installed applications](#list-the-installed-applications)
  - [List and query all the applications available on the database](#list-and-query-all-the-applications-available-on-the-database)
  - [Update all](#update-all)
  - [Backup and restore installed apps using snapshots](#backup-and-restore-installed-apps-using-snapshots)
  - [Remove one or more applications](#remove-one-or-more-applications)
  - [Convert Type2 AppImages requiring libfuse2 to New Generation AppImages](#convert-type2-appimages-requiring-libfuse2-to-new-generation-appimages)
  - [Integrate local AppImages into the menu by dragging and dropping them](#integrate-local-appimages-into-the-menu-by-dragging-and-dropping-them)
    - [How to create a launcher for a local AppImage](#how-to-create-a-launcher-for-a-local-appimage)
    - [How to remove the orphan launchers](#how-to-remove-the-orphan-launchers)
    - [AppImages from external media](#appimages-from-external-media)
  - [How to use "AM" in non-privileged mode, like "AppMan"](#how-to-use-am-in-non-privileged-mode-like-appman)
  - [Sandbox an AppImage](#sandbox-an-appimage)
    - [How to enable a sandbox](#how-to-enable-a-sandbox)
    - [How to disable a sandbox](#how-to-disable-a-sandbox)
    - [Sandboxing example](#sandboxing-example)
    - [About Aisap sandboxing](#about-aisap-sandboxing)
  - [How to enable bash completion](#how-to-enable-bash-completion)
  - [How to update or remove apps manually](#how-to-update-or-remove-apps-manually)
  - [Downgrade an installed app to a previous version](#downgrade-an-installed-app-to-a-previous-version)
  - [Create and test your own installation script](#create-and-test-your-own-installation-script)
    - [Option Zero: "AppImages"](#option-zero-appimages)
    - [Option One: "build AppImages on-the-fly"](#option-one-build-appimages-on-the-fly)
    - [Option Two: "Archives and other programs"](#option-two-archives-and-other-programs)
    - [Option Three: "Firefox profiles"](#option-three-firefox-profiles)
    - [How an installation script works](#how-an-installation-script-works)
    - [How to test an installation script](#how-to-test-an-installation-script)
  - [Third-party databases for applications (NeoDB)](#third-party-databases-for-applications-neodb)

__________________________________________________________________________
## Install applications
The option `-i` or `install` is the one responsible of the installation of apps or libraries.

### Install, normal behaviour
This is the normal syntax:
```
am -i $PROGRAM
```
or
```
appman -i $PROGRAM
```
in this video I'll install AnyDesk:

https://github.com/user-attachments/assets/62bc7444-8b1f-4db2-b23b-db7219eec15d

### Install, debug an installation script
The "install.am" module contains some patches to disable long messages. You can see them with the suboption `--debug`:
```
am -i --debug $PROGRAM
```
or
```
appman -i --debug $PROGRAM
```
let test again the installation of AnyDesk using the `--debug` flag:

https://github.com/user-attachments/assets/9dd73186-37e2-4742-887e-4f98192bd764

### Install the "latest" stable release instead of the latest "unstable"
By default, many installation scripts for apps hosted on github will point to the more recent generic release instead of "latest", which is normally used to indicate that the build is "stable". This is because upstream developers do not always guarantee a certain packaging format in "latest", sometimes they may only publish packages for Windows or macOS, so pointing to "latest" would not guarantee that any package for Linux will be installed.

On the other hand, if you know that the upstream developer will always guarantee a Linux package in "latest" and "AM" instead points to a potentially unstable development version (Alpha, Beta, RC...), this is the syntax to adopt:
```
am -i --force-latest $PROGRAM
```
or
```
appman -i --force-latest $PROGRAM
```
in this video I'll install "SqliteBrowser" using the `--force-latest` flag:

https://github.com/user-attachments/assets/ee29adfd-90e1-46f7-aed9-b9c410f68776

See also "[The script points to "releases" instead of downloading the latest stable](#the-script-points-to-releases-instead-of-downloading-the-latest-stable)".

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
## Install only AppImages
All suboption for `-i`/`install` listed above can be used to install AppImages only, it is enough to use the option `-ia`/`install-appimage`:
```
am -ia {PROGRAM}
am -ia --debug {PROGRAM}
am -ia --force-latest {PROGRAM}
```
or
```
appman -ia {PROGRAM}
appman -ia --debug {PROGRAM}
appman -ia --force-latest {PROGRAM}
```
In this example, I'll run the script `brave-appimage` but running `brave`, that instead is the original upstream package:

https://github.com/user-attachments/assets/b938430c-ec0b-4b90-850f-1332063d5e53

in the video above I first launch a "query" with the `-q` option to show you the difference between `brave` and `brave-appimage`, and then `-q --appimages` to show you only the appimages from the list. More details at "[List and query all the applications available on the database](#list-and-query-all-the-applications-available-on-the-database)".

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### Install AppImages not listed in this database but available in other github repos
From version 7.2 its possible to install AppImages not listed in this database, thanks to the option `-e` or `extra`.

You need to add the URL to the github repo before the name you want to give to the AppImage (for command line usage, for example).

Optionally, you can add a "keyword" if more AppImages are listed in the same repo.

Usage:
```
am -e $USER/$PROJECT $PROGRAM
am -e $USER/$PROJECT $PROGRAM $KEYWORD
```
or
```
appman -e $USER/$PROJECT $PROGRAM
appman -e $USER/$PROJECT $PROGRAM $KEYWORD
```
You can give whatever name you want to the apps (as long as they does not overlap with commands already existing on your system, be careful).

In this video I'll install AnyDesk as "remote-desktop-client":

https://github.com/user-attachments/assets/aa546905-38da-48b5-bb10-658426e8372b

In this other example, I'll install an obsolete version of WINE AppImage, from a repo that lists more versions of the same app:
1. the first attempt is without a keyword, so that the script picks the first AppImage in the list (for Debian Buster)
2. in the second attempt I'll use the keyword "arch" to pick the Arch-based AppImage

https://github.com/user-attachments/assets/af00a5f2-f3fe-4616-899a-155cb31d2acd

As you can see, there are all the files needed by any app listed in this database, also if an installation script for them does not exists.

Apps installed this way will enjoy the same benefits as those that can already be installed from the database with the "`-i`" or "`install`" option [mentioned above](#install-applications), including updates and sandboxing.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### List the installed applications
Option `-f` or `files`, it shows the installed apps, the version, the size and the type of application:

https://github.com/ivan-hc/AM/assets/88724353/a11ccb22-f2fa-491f-85dd-7f9440776a54

By default apps are sorted by size, use "`--byname`" to sort by name. With the option "`--less`" it shows only the number of installed apps.
```
am -f
am -f --byname
am -f --less
```
or
```
appman -f
appman -f --byname
appman -f --less
```

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### List and query all the applications available on the database
Option `-l` or `list` shows the whole list of apps available in this repository.

This option uses `less` to show the list, so to exit its enough to press "**Q**".

If the option `-l` is followed by `--appimages`, you will be able to see only the available AppImages.

https://github.com/user-attachments/assets/eae9ea83-d1f7-4f15-8acf-0cfb7a75a1af

Option `-q` or `query` shows search results from the list above.

If followed by `--appimages`, the search results will be only for the available AppImages.

If followed by `--pkg`, all keywords will be listed also if not on the same line. This is good if you are looking for multiple packages.

https://github.com/user-attachments/assets/1b2f3f3b-fe22-416f-94d8-d5e0465b3f6d

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### Update all
Option `-u` or `update` updates all the installed apps and keeps "AM"/"AppMan" in sync with the latest version and all latest bug fixes:

https://github.com/ivan-hc/AM/assets/88724353/f93ca782-2fc6-45a0-a3f2-1fba297a92bf

See "[How to update all programs, for real](#how-to-update-all-programs-for-real)".

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### Backup and restore installed apps using snapshots

#### Backup
Option `-b` or `backup` creates a copy of the installed app into a dedicated directory under $HOME/.am-snapshots:

https://github.com/ivan-hc/AM/assets/88724353/ae581bc0-f1c5-47da-a2c4-3d01c37cc5a4

Each snapshot is named with the date and time you have done the backup. To restore the application to a previous version, copy/paste the name of the snapshot when the `-o` option will prompt it.

#### Restore
Option `-o` or `overwrite` lists all the snapshots you have created with the option `-o` (see above), and allows you to overwrite the new one:

https://github.com/ivan-hc/AM/assets/88724353/f9904ad2-42ec-4fce-9b21-b6b0f8a99414

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### Remove one or more applications
Option `-R` removes the selected apps without asking (to have a prompt, use `-r` or `remove`):

https://github.com/ivan-hc/AM/assets/88724353/4d26d2d7-4476-4322-a0ab-a0a1ec14f751

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### Convert Type2 AppImages requiring libfuse2 to New Generation AppImages
Option `nolibfuse` converts old Type2 AppImages asking for "libfuse2" into new generation AppImages:
```
am nolibfuse $PROGRAM
```
or
```
appman nolibfuse $PROGRAM
```
in this example, I'll convert Libreoffice and Kdenlive:

https://github.com/user-attachments/assets/494d0d92-f46c-4d4e-b13d-f1d01168fb8f

As you can see, the file sizes are also smaller than before.

This process only works for old AppImages that still depend on "libfuse2", other files will be ignored.

The original AppImage will be extracted using the `--appimage-extract` option, and then repackaged using `appimagetool` from https://github.com/AppImage/appimagetool 

#### Updating converted AppImages
The `nolibfuse` option adds the following lines at the end of the AM-updater script
```
echo y | am nolibfuse $APP
notify-send "$APP has been converted too! "
```
or
```
echo y | appman nolibfuse $APP
notify-send "$APP has been converted too! "
```
so if an update happens through "comparison" of versions, the converted AppImage will be replaced by the upstream version and then the `nolibfuse` option will automatically start the conversion (prolonging the update time, depending on the size of the AppImage). In this example, I update all the apps, including the original Avidemux, that is an old Type2 AppImage:

https://github.com/user-attachments/assets/03683d8b-32d8-4617-83e3-5278e33b46f4

Instead, if the installed AppImage can be updated via `zsync`, **this may no longer be updatable**, anyway a solution may be the use of `appimageupdatetool`, at https://github.com/AppImageCommunity/AppImageUpdate .

The `nolibfuse` option has been improved since version 7.8, so everyone can say goodbye to the old "libfuse2" dependence.

Anyway, **I suggest anyone to contact the developers to update the packaging method of their AppImage!** This is also a way to keep open source projects alive: your participation through feedback to the upstream.

The `nolibfuse` option is not intended to replace the work of the owners of these AppImage packages, but to encourage the use of AppImage packages on systems that do not have "libfuse2", a library that is now obsolete and in fact no longer available out-of-the-box by default in many distributions, first and foremost Ubuntu and Fedora.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### Integrate local AppImages into the menu by dragging and dropping them
If you are a user who is used to dragging your local AppImages scattered around the system and if you are a user who likes clutter and wants to place their packages in different places... this option is for you.

The option `--launcher` allows you to drag and drop a local AppImage to create a launcher to place in the menu, like any other classic AppImage helper would... but in SHELL.

This option also allows you to create a symbolic link with the name you prefer, in "`~/.local/bin`". Leave blank to let the option create a shell script that calls your AppImage, with extension ".appimage", lowercased.

##### How to create a launcher for a local AppImage
```
am --launcher /path/to/File.AppImage
```
or
```
appman --launcher /path/to/File.AppImage
```
In this video I'll integrade Brave AppImage, the first time without a name, and the second time by choosing "brave" (NOTE, the ".appimage" in $PATH is a little shell script that calls the AppImage, not the whole AppImage):

https://github.com/user-attachments/assets/caa22ab7-b6a4-45c4-bd33-27316251e267

Now the binaries are "two", keep read to see how to remove them using "AM" and "AppMan".

##### How to remove the orphan launchers
In case you move your AppImages somewhere else or remove them, use the following otion `-c` or `clean` to get rid of all the orphaned launchers and dead symlinks and scripts you created earlier:
```
am -c
```
or
```
appman -c
```
In this video I'll remove the AppImage, and then I'll remove the launchers and items in $PATH created in the previous video (see above):

https://github.com/user-attachments/assets/2dedf1a9-43c2-455c-8c97-2023bedc4203

##### AppImages from external media
Another peculiarity concerns the use of the `-c` option on launchers created on AppImage packages placed on removable devices:
- if in the .desktop file belongs to an AppImage placed in /mnt or /media and none of the references are mounted, the option `-c` will not be able to remove it until you mount the exact device where it was placed in the moment you have created the launcher;
- if you mount that same device and the AppImage is not where it was when you created the launcher, it will be removed.

This is very useful if you have large AppImage packages that you necessarily need to place in a different partition.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### Sandbox an AppImage
Since version 6.12, "AM"/"AppMan" uses Bubblewrap for sandboxing AppImage packages, thanks to "[Aisap](https://github.com/mgord9518/aisap)", a highly intuitive and configurable command line solution.

The option "`--sandbox`", which since version 5.3 was using Firejail, has taken on a completely different appearance and usability, thanks to the intense work of @Samueru-sama, who managed to extend and enhance "Aisap", making it extremely easy to use in our project, to the point of making us forget that we are using a command line utility.

[Bubblewrap](https://github.com/containers/bubblewrap) is an highly used sanboxing solution, used in multiple projects for GNU/Linux, including Flatpak.

In this sense, "Aisap" may be considered a reference point for the future of AppImages sandboxing!

#### How to enable a sandbox
This method works as follows:
```
am --sandbox $APP
```
or
```
appman --sandbox $APP
```
The "aisap" package installed is required, whether it is available system-wide ("AM") or locally ("AppMan"), the important thing is that the "aisap" command is in $PATH. If it is not present, "AM"/"AppMan" will ask you if it can proceed with the installation before continuing.

We will first compile the Aisap script in a non-privileged, easy-to-access directory, before being placed in $PATH (see step 2, below).
1. Once started, you will be asked whether to enable the sandbox (default "Y") or not (type "N"):
  - the main XDG directories (Pictures, Videos, Documents...) will be listed, answer whether to authorize access (type "Y") or not ("N", default);
  - at the end, choose whether to specify some directories to access (default "N"), and if "Yes", write the path.
2. Now that the script is complete, it should be placed in $PATH. "AM" users will need to authorize writing to /usr/local/bin by entering their password. "AppMan" users do not have these problems;
3. To allow Aipman take care of the AppImage, the latter be set to "not executable" and the related AM-updater will also have its `chmod` command set from `a+x` to `a-x`.
4. Now your AppImage is in a sandbox!

NOTE, the default location for the sandboxed homes is at $HOME/.local/am-sandboxes, but that location can be changed by setting the $SANDBOXDIR environemt variable.

#### How to disable a sandbox
To remove the sandbox just run the command of the AppImage with the flag "--disable-sandbox", like this:
```
$APP --disable-sandbox
```

#### Sandboxing example
In the video below we will use "Baobab" (GTK3 version), a disk space analyzer, available in the database as "baobab-gtk3".

Among the XDG directories we will authorize "Images" (Pictures) and "Videos" (Videos), while manually we will authorize "Public". The test will be carried out in normal mode, then in sandbox and again without sandbox:

https://github.com/ivan-hc/AM/assets/88724353/dd193943-7b08-474a-bbbb-4a6906de8b24

#### About Aisap sandboxing
For more information about "Aisap", visit https://github.com/mgord9518/aisap

Available profiles are listed at https://github.com/mgord9518/aisap/tree/main/profiles

To learn more about permissions, see https://github.com/mgord9518/aisap/tree/main/permissions

EXTRA: The behavior of this option can be tested in a completely standalone way by consulting the repository of its creator, at [Samueru-sama/aisap-am](https://github.com/Samueru-sama/aisap-am)

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to enable bash completion
**From version 8**, BASH/ZSH completion is enabled in "AM" and "AppMan" by default, and **from version 8.1.1** a file in $HOME/.local/share/bash-completion/completions named "am" or "appman" (and no more $HOME/.bash_completion) will be created to read arguments from the related "list" of arguments, or other lists, to made it more extensible.

Before version 8, in "AM" were created a "/etc/bash_completion.d/am-completion.sh" using a dedicated option.

In case you still have it, run `sudo rm -f /etc/bash_completion.d/am-completion.sh` to remove it. Its no more necessary.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to update or remove apps manually
Inside each installed applications directory, there are two scripts called "AM-updater" and "remove", and their purpose is indicated in their name:
- To update an app manually, run the AM-updater script.
- To remove an application instead, run the "remove" script (with "`sudo`" or "`doas`" if you are an "AM" user).

__________________________________________________________________________
### Downgrade an installed app to a previous version
Use the `--rollback` option or `downgrade` in this way:
```
am --rollback ${PROGRAM}
```
This only works with the apps hosted on Github.

https://github.com/ivan-hc/AM/assets/88724353/8f286711-7934-461a-8bc2-b3a3e1d5f269

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### Create and test your own installation script
Option `-t` or `template` allows you to create an "AM" compatible installation script using a "[templates](https://github.com/ivan-hc/AM/tree/main/templates)" that can be used by both "AM" and "AppMan". In fact, all AppMan does is take the installation scripts from this database and patch them to make them compatible with a rootless installation.

The syntax to follow is this
```
am -t $PROGRAM
```
or
```
appman -t $PROGRAM
```
The available options are as follows:

0. Create a script for an AppImage package
1. Build an AppImage on the fly using [appimagetool](https://github.com/AppImage/AppImageKit) and [pkg2appimage](https://github.com/AppImage/pkg2appimage)
2. Download and unpack a generic archive (ZIP, TAR...)
3. Create a custom Firefox profile

To learn more about a specific option, use the index below
- [Option Zero: "AppImages"](#option-zero-appimages)
- [Option One: "build AppImages on-the-fly"](#option-one-build-appimages-on-the-fly)
- [Option Two: "Archives and other programs"](#option-two-archives-and-other-programs)
- [Option Three: "Firefox profiles"](#option-three-firefox-profiles)

Otherwise, go directly to the last paragraphs, which are
- [How an installation script works](#how-an-installation-script-works)
- [How to test an installation script](#how-to-test-an-installation-script)

![Istantanea_2024-06-17_21-35-26 png](https://github.com/ivan-hc/AM/assets/88724353/6e11aeff-9a70-44f7-bd73-1324b545704e)

#### Option Zero: "AppImages"
The easiest script to create is certainly the one relating to AppImages, the "Zero" option.
1. Enter the URL of the site
   - if the AppImage is hosted on github, it will quickly detect the URL
   - if the AppImage is not hosted on github,it will ask you to add a description of the app
2. Detecting the  correct URL
   - if the app is hosted on github, it will ask you if you want to add/remove keywords to use in `grep`, to detect the correct URL, else press ENTER
   - if the app is not hosted on github, add a one-line command to detect the latest version of the app (advanced)
  
In this video I'll create 2 installation scripts:
- the first one is for "gimp", detected as first reference, no extra prompts
- the second one is for "baobab-gtk3", hosted on a repository with multiple packages, so I have to add a keyword ("baobab"), univoque for the URL I'm interested in

https://github.com/ivan-hc/AM/assets/88724353/b6513e8a-17ab-4671-baf7-d86183d57c11

#### Option One: "build AppImages on-the-fly"
This was one of the very first approaches used to create this project. Before I started building AppImage packages myself, they were first compiled just like using any AUR-helper.

From version 7.1, the installation script for the AppImages is used, with the only difference that it points only to the version, while a second script will be downloaded, published separately, at [github.com/ivan-hc/AM/tree/main/appimage-bulder-scripts](https://github.com/ivan-hc/AM/tree/main/appimage-bulder-scripts), which will have the task of assembling the AppImage in the directory on the fly "tmp", during the installation process. When the second script has created the .AppImage file, the first script will continue the installation treating the created AppImage as a ready-made one downloaded from the internet.

In this video we see how "calibre" is installed (note that a "calibre.sh" file is downloaded during the process):

https://github.com/ivan-hc/AM/assets/88724353/e439bd09-5ec6-4794-8b00-59735039caea

In this video, I run the aforementioned "calibre.sh" script in a separate directory, in a completely standalone way:

https://github.com/ivan-hc/AM/assets/88724353/45844573-cecf-4107-b1d4-7e8fe3984eb1

Two different operations (assembly and installation) require two different scripts.

Fun fact, up until version 7, this option included a unique template that installed and assembled the AppImage on the fly (see [this video](https://github.com/ivan-hc/AM/assets/88724353/6ae38787-e0e5-4b63-b020-c89c1e975ddd)). This method has been replaced as it was too pretentious for a process, assembly, which may instead require many more steps, too many to be included in both an installation script and an update script (AM-updater).

#### Option Two: "Archives and other programs"
Option two is very similar to option zero. What changes is the number of questions, which allow you to customize both the application's .desktop file and the way a program should be extracted.

This script also supports extraction of *7z, *tar* and *zip files, if those archives are downloaded instead of a standalone binary.

By default, the install script does not have a launcher and icon. To create one, press "Y", otherwise, press "N" or leave it blank. This is useful if you want to load scripts or tools that can be used from the command line.

This option may be used also for AppImages, if you need to customize the launcher.

Tu add an icon, you need an URL to that, but if you don't have one, just leave blank. The script will download an icon from [portable-linux-apps.github.io](https://portable-linux-apps.github.io/) if it is hosted there, when running the installation script.

In this example, I'll use OBS Studio AppImage.

https://github.com/ivan-hc/AM/assets/88724353/ce46e2f2-c251-4520-b41f-c511d4ce6c7d

#### Option Three: "Firefox profiles"
Option 3 creates a launcher that opens Firefox in a custom profile and on a specific page, such as in a WebApp. I created this option to counterbalance the amount of Electron/Chrome-based applications (and because I'm a firm Firefox's supporter).

#### How an installation script works
The structure of an installation script is designed for a system-wide installation, with "AM", since it is intended to be hosted in the database. But every path indicated within it is written so that "AppMan" can patch the essential parts, to hijack the installation at a local level and without root privileges:
1. In the first step, the variables are indicated, such as the name of the application and a reference to the source of the app (mostly used in `--rollback` or `downgrade`);
2. Create the directory of the application;
3. The first file to be created is "`remove`", to quickly remove app's pieces in case of errors;
4. Create the "tmp" directory, in which the app will be downloaded and, in the case of archives, extracted;
5. Most scripts contain a "$version" variable, a command to intercept the URL to download the app. If the URL is linear and without univoque versions, "$version" can be used to detect a version number. Then save the value into a file "version" (this is important for the updates, see point 7);
6. Downloading the application (and extract it in case of archive);
7. Create the "AM-updater" file, the script used to update the app. It resumes points 4, 5 and 6, with the difference that the "$version" variable we have saved at point 5 is compared with a new value, hosted at the app's source;
8. Creation/extract/download launcher and icon, the methods change depending on the type of application. For AppImages they are extracted from the package.

#### How to test an installation script
To install and test your script, use the command
```
am -i /path/to/your-script
```
or
```
appman -i /path/to/your-script
```
To debug the installation, add the option `--debug`, like this
```
am -i --debug /path/to/your-script
```
or
```
appman -i --debug /path/to/your-script
```
__________________________________________________________________________
### Third-party databases for applications (NeoDB)
Use the option `newrepo` or `neodb` to add new repositories to use instead of this one. This works for both online and offline repositories.

Set a new default repo, use "add" to append the path to a local directory or an online URL:
```
am newrepo add {URL}\{PATH}
```
or
```
appman newrepo add {URL}\{PATH}
```
then use "select" to use it by default:
```
am newrepo select
```
or
```
appman newrepo select
```
a message will warn you about the usage of this repo instead of the default one.

In the screenshot below, I'm adding an offline directory and an online "RAW" fork of "AM"
![Istantanea_2024-08-25_20-10-47](https://github.com/user-attachments/assets/599f1c11-e2dd-4343-ac51-32e0eeb2643f)

Use "on"/"off" to enable/disable it:
```
am newrepo on
am newrepo off
```
or
```
appman newrepo on
appman newrepo off
```
Use "purge" to remove all 3rd party repos:
```
am newrepo purge
```
or
```
appman newrepo purge
```
Use "info" to see the source from where installation scripts and lists are taken.
```
am newrepo info
```
or
```
appman newrepo info
```
if no third-party repo is in use, you will see the default URLs from this repo.

![Istantanea_2024-08-25_20-07-54 png](https://github.com/user-attachments/assets/793e64b9-7377-424c-a70e-a83e89c5225c)

------------------------------------------------------------------------

| [Install "AM"/"AppMan"](#installation) | [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - | - |

------------------------------------------------------------------------
# Troubleshooting

- [An application does not work, is old and unsupported](#an-application-does-not-work-is-old-and-unsupported)
- [Cannot download or update an application](#cannot-download-or-update-an-application)
- [Cannot mount and run AppImages](#cannot-mount-and-run-appimages)
- [Spyware, malware and dangerous software](#spyware-malware-and-dangerous-software)
- [Stop AppImage prompt to create its own launcher, desktop integration and doubled launchers](#stop-appimage-prompt-to-create-its-own-launcher-desktop-integration-and-doubled-launchers)
- [The script points to "releases" instead of downloading the latest stable](#the-script-points-to-releases-instead-of-downloading-the-latest-stable)
- [Wrong download link](#wrong-download-link)

------------------------------------------------------------------------
### An application does not work, is old and unsupported
Use the `-a` option and go to the developer's site to report the problem. The task of "AM" is solely to install / remove / update the applications managed by it. Problems related to the failure of an installed program or any related bugs are attributable solely to its developers.

------------------------------------------------------------------------
### Cannot download or update an application
There can be many reasons:
- check your internet connection;
- if the app is hosted on github.com, you have probably exceeded the hourly limit of API calls;
- the referring link may have been changed, try the `--rollback` option or `downgrade`;
- the reference site has changed, report any changes at https://github.com/ivan-hc/AM/issues
------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------
### Cannot mount and run AppImages
If by running it in the terminal you get an error message about "FUSE" or "libfuse"/"libfuse2" missing, take a look at the official documentation:

https://docs.appimage.org/user-guide/troubleshooting/fuse.html

If your distro does not provide `libfuse2`, you can install it using the command:
```
am -i libfuse2
```
or
```
appman -i libfuse2
```
NOTE, in AppMan you still need to use your password (`sudo` or `doas`) to install the library at system level, in /usr/local/lib

Alternatively you can use the "`nolibfuse`" option to "try" to convert old Type2 AppImages to a new generation one, so as not to depend on `libfuse2`. In most cases it works, but sometimes it can give errors, depending on how the package was manufactured.

However, I suggest contacting the upstream developers to convince them to upgrade their packages.

* **If you cannot run some AppImages on Ubuntu 23.10+ or its derivatives, then refer to [Restricted unprivileged user namespaces are coming to Ubuntu 23.10 | Ubuntu](https://ubuntu.com/blog/ubuntu-23-10-restricted-unprivileged-user-namespaces) for possible causes and remedies.**
* **If you cannot run chrome/chromium/electron-based AppImages, then refer to [Troubleshooting/Electron-sandboxing](https://docs.appimage.org/user-guide/troubleshooting/electron-sandboxing.html) for possible causes and remedies.**

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------
### Spyware, malware and dangerous software
Before installing any application, try to know where it comes from first. This program provides you with two basic options for this purpose:
- Option `-a` or `about` (medium safety), allows you to read a short description and know the links from the pages of the site [https://portable-linux-apps.github.io](https://portable-linux-apps.github.io) locally, however these links may be inaccurate due to continuous updates of the initial scripts (you can provide additional info yourself by modifying the pages of the site, [here](https://github.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io), it is also open source);
- Option `-d` or `download` (absolute safety), this allows you to get the installation script directly on your desktop, so you can read the mechanisms and how it performs the downloads from the sources (in most cases there is a header for each step that explains what the listed commands do).

“AM” and AppMan are just tools to easily install all listed programs, but what you choose to install is your complete responsibility. **Use at your own risk**!

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------
### Stop AppImage prompt to create its own launcher, desktop integration and doubled launchers
Some developers insist on creating Appimages that create their own launcher on first launch (like WALC and OpenShot). If the official solution proposed [here](https://discourse.appimage.org/t/stop-appimage-from-asking-to-integrate/488) doesn't work, you have two options to escape this trouble: "`-H`" and "`--sandbox`".

**1. Option "-H" or "home": create a .home directory for the AppImage**

Use the option `-H`, then launch the app and accept the request. Dotfiles and launcher will be saved in the $APP.home near the AppImage:
```
am -H $APP
$APP
```
or
```
appman -H $APP
$APP
```
you can also use the AppImage's builtin option `--appimage-portable-home` from the terminal:
```
$APP --appimage-portable-home
```
This method works in the 99% of cases.

**2. Option "--sandbox": run the AppImage into a Aisap/bubblewrap sandbox**

Use the option `--sandbox`, then launch the app and accept the request. Dotfiles and launcher will be saved in the dedicated sandbox:
```
am ---sandbox $APP
$APP
```
or
```
appman --sandbox $APP
$APP
```
This is the best method, since you decide wheter to allow the use of user's directories or not.

For more details, see "[**Sandbox an AppImage**](#sandbox-an-appimage)".

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------
### The script points to "releases" instead of downloading the latest stable
This is a choice I made as many developers have abandoned support for AppImage or GNU/Linux in general. My aim here is to introduce you to other developers' applications, then it's up to you to contact them, support them, help improve the software through forks and pull requests, opening issues and encouraging developers to keep the software in the format you prefer.

In case you are sure that the upstream developer will maintain the package for each stable release, you can fix this in several ways:
#### Method 1: Direct installation by combining `-i` and `--force-latest` options
```
am -i --force-latest $PROGRAM
```
#### Method 2: "Downgrade" the installed app to "latest"
Use the option `--force-latest` to patch the AM-updater and perform the "update"/"downgrade":
```
am --force-latest $PROGRAM
```
or do it manually:
```
sed -i 's#releases -O -#releases/latest -O -#g' /opt/$PROGRAM/AM-updater
am -u $PROGRAM
```

See also "[Install the "latest" stable release instead of the latest "unstable"](#install-the-latest-stable-release-instead-of-the-latest-unstable)".

------------------------------------------------------------------------
### Wrong download link
The reasons may be two:
- the referring link may have been changed, try the `--rollback` option or `downgrade`;
- the reference site has changed, report any changes at https://github.com/ivan-hc/AM/issues

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------
# Related projects
#### External tools and forks used in this project
- [aisap](https://github.com/mgord9518/aisap), sandboxing solutions for AppImages
- [appimagetool](https://github.com/AppImage/appimagetool), get rid of libfuse2 from your AppImages
- [pkg2appimage](https://github.com/AppImage/pkg2appimage), create AppImages on the fly from existing .deb packages
- [repology](https://github.com/repology), the encyclopedia of all software versions

#### My other projects
- [AppImaGen](https://github.com/ivan-hc/AppImaGen), easily create AppImages from Ubuntu PPAs or Debian using pkg2appimage and appimagetool;
- [ArchImage](https://github.com/ivan-hc/ArchImage), create AppImages for all distributions using Arch Linux packages. Powered by JuNest;
- [Firefox for Linux scripts](https://github.com/ivan-hc/Firefox-for-Linux-scripts), easily install the official releases of Firefox for Linux;
- [My AppImage packages](https://github.com/ivan-hc#my-appimage-packages) the complete list of packages managed by me and available in this database;
- [Snap2AppImage](https://github.com/ivan-hc/Snap2AppImage), try to convert Snap packages to AppImages.

------------------------------------------------------------------------

###### *You can support me and my work on [**ko-fi.com**](https://ko-fi.com/IvanAlexHC) and [**PayPal.me**](https://paypal.me/IvanAlexHC). Thank you!*

--------

*© 2020-present Ivan Alessandro Sala aka 'Ivan-HC'* - I'm here just for fun! 

------------------------------------------------------------------------

| [**ko-fi.com**](https://ko-fi.com/IvanAlexHC) | [**PayPal.me**](https://paypal.me/IvanAlexHC) | [Install "AM"/"AppMan"](#installation) | ["Main Index"](#main-index) |
| - | - | - | - |

------------------------------------------------------------------------
