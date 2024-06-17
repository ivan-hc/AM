# "AM" Application Manager
### Database & solutions for all AppImages and portable apps for GNU/Linux!

![Istantanea_2024-06-17_16-23-49 png](https://github.com/ivan-hc/AM/assets/88724353/ff4709c8-a3b2-4a1e-84ab-72700934809f)

"AM"/"AppMan" is a set of scripts and modules for installing, updating, and managing AppImage packages and other portable formats, in the same way that APT manages DEBs packages, DNF the RPMs, and so on... using a large database of Shell scripts inspired by the Arch User Repository, each dedicated to an app or set of applications.

The engine of "AM"/"AppMan" is the "APP-MANAGER" script which, depending on how you install or rename it, allows you to install apps system-wide (for a single system administrator) or locally (for each user).

"AM"/"AppMan" aims to be the default package manager for all AppImage packages, giving them a home to stay.

You can consult the entire **list of managed apps** at [**portable-linux-apps.github.io/apps**](https://portable-linux-apps.github.io/apps).

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

[Troubleshooting](#troubleshooting)

[Related projects](#related-projects)

------------------------------------------------------------------------
# Differences between "AM" and "AppMan"
"AM" and "AppMan" differ in how they are installed, placed and renamed in the system and how/where they install apps:
- "**AM**" is installed system-wide (requires `sudo`) in `/opt/am/` as "**APP-MANAGER**", with a symlink named "`am`" in `/usr/local/bin`.
- "**AppMan**" is portable, you need just to rename the "APP-MANAGER" script as "`appman`" and put it wherewer you want. I recommend to place it in `$HOME/.local/bin` to be used in $PATH, to be managed from other tools (see below).

Both can be updated using "[Topgrade](https://github.com/topgrade-rs/topgrade)".

### Ownership
- "**AM**" is owned by the user that have installed it, since other users have not read/write permissions in "/opt/am";
- "**AppMan**" is for all users, since it works locally, everyone can have its own apps and configurations.

### About "sudo" usage
- "AppMan" can request the root password only in the very rare case in which you want to install a library;
- "AM" requires the root password only to install, remove apps, enable a sandbox for an AppImage, or enable/disable bash completion.

All options cannot be executed with "`sudo`".

### How apps are installed
- "**AM**" installs apps system wide, in `/opt` (see [Linux Standard Base](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s13.html)), using the following structure:
```
/opt/$PROGRAM/
/opt/$PROGRAM/$PROGRAM
/opt/$PROGRAM/AM-updater
/opt/$PROGRAM/remove
/opt/$PROGRAM/icons/$ICON-NAME
/usr/local/bin/$PROGRAM
/usr/share/applications/AM-$PROGRAM.desktop
```
If the distro is immutable or have read-only mount points instead, the path of the launcher (the last line above) will change like this:
```
/usr/local/share/applications/AM-$PROGRAM.desktop
```

- "**AppMan**" is more flexible, since it asks you where to install the apps in your $HOME directory. For example, suppose you want install everything in "Applicazioni" (the italian of "applications"), this is the structure of what an installation scripts installs with "AppMan" instead:
```
~/Applicazioni/$PROGRAM/
~/Applicazioni/$PROGRAM/$PROGRAM
~/Applicazioni/$PROGRAM/AM-updater
~/Applicazioni/$PROGRAM/remove
~/Applicazioni/$PROGRAM/icons/$ICON-NAME
~/.local/bin/$PROGRAM
~/.local/share/applications/AM-$PROGRAM.desktop
```
The configuration file for AppMan is in `~/.config/appman` and contains the path you indicated at first startup. Changing its contents will result in changing the paths for each subsequent operation carried out with "AppMan", the apps and modules stored in the old path will not be manageable.

At first startup you can indicate any directory or subdirectory you want, as long as it is in your $HOME.

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

------------------------------------------------------------------------

| [Back to "Main Index"](#main-index) |
| - |

------------------------------------------------------------------------
# Installation
This section explains how to install "AM" or "AppMan".

If you don't know the difference, please read "[Differences between "AM" and "AppMan"](#differences-between-am-and-appman)" first.

Below are the essential dependencies for both "AM" and "AppMan":
- "`coreutils`", is usually installed by default in all distributions as it contains basic commands ("`cat`", "`chmod`", "`chown`"...);
- "`curl`", to check URLs;
- "`grep`", to check files;
- "`jq`", to handle JSON files (some scripts need to check a download URL from api.github.com);
- "`sed`", to edit/adapt installed files;
- "`wget`" to download all programs and update "AM"/"AppMan" itself;

NOTE, "AM" require "`sudo`" to be installed.

If for some reason you don't use `sudo` and you prefer to gain administration privileges using alternative commands such as `doas` or similar, simply use "AppMan".

<details>
  <summary>See also optional dependencies, click here!</summary>

#### Listed below are optional dependencies that are needed only by some programs:
- "`binutils`", contains a series of basic commands, including "`ar`" which extracts .deb packages;
- "`unzip`", to extract .zip packages;
- "`tar`", to extract .tar* packages;
- "`zsync`", about 10% of AppImages depend on this to be updated.

</details>

- [How to install "AM"](#how-to-install-am)
- [How to install "AppMan"](#how-to-install-appman)


## How to install "AM"
"**AM**" is ment to be installed at system level to manage apps.

The script "[INSTALL](https://github.com/ivan-hc/AM/blob/main/INSTALL)" is the one that take care of this.

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
- the directory "/opt/am/.cache" (where all processes will been executed)
- the directory "/opt/am/modules" (containing the .am modules for the non-core options)
- the symlink "/usr/local/bin/am" for "/opt/am/APP-MANAGER"

NOTE, if you don't feel comfortable having to always use root permissions, the installation method for "AppMan" is totally different. If you are interested, go [to the next paragraph](#how-to-install-appman), else [Back to "Main Index"](#main-index) or jump to "[Usage (all the available options)](#usage)".

------------------------------------------------------------------------
## How to install "AppMan"
"**AppMan**" can be used in different places, being it portable.

However, to be easily used its recommended to place it in your local "$PATH", in `~/.local/bin`.

#### Use "AppMan" in "$PATH"
To do so, you must first enable that "$PATH":
- add `export PATH=$PATH:$(xdg-user-dir USER)/.local/bin` in the ` ~/.bashrc`
- create the directory `~/.local/bin` if it is not available

To do all this quickly, simply copy/paste the following command:
```
mkdir -p ~/.local/bin && echo 'export PATH=$PATH:$(xdg-user-dir USER)/.local/bin' >> ~/.bashrc && wget https://raw.githubusercontent.com/ivan-hc/AM/main/APP-MANAGER -O appman && chmod a+x ./appman && mv ./appman ~/.local/bin/appman
```
#### Use "AppMan" in "Portable Mode"
"AppMan" can run in any directory you download it, copy/paste the following command to download "APP-MANAGER", rename it to `appman` and make it executable:
```
wget https://raw.githubusercontent.com/ivan-hc/AM/main/APP-MANAGER -O appman && chmod a+x ./appman
```

### Structure of the "AppMan" installation
Unlike "AM" which needs to be placed in specific locations, "AppMan" is portable. The modules and directories will be placed in the directory you chose:
- the script "appman" is wherever you want
- the directory "$HOME/path/to/your/custom/directory/.cache" (where all processes will been executed)
- the directory "$HOME/path/to/your/custom/directory/modules" (containing the .am modules for the non-core options)
- the configuration file "$HOME/.config/appman/appman-config" (the only fixed directory)

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

 ## OPTIONS

 (standard, for both "AM" and "APPMAN")
 ___________________________________________________________________________
 ___________________________________________________________________________

 `-a`, `about`

 SYNOPSIS:

 `-a {PROGRAM}`

 DESCRIPTION: 	Shows more info about one or more apps, all the pages are downloaded from https://portable-linux-apps.github.io
 ___________________________________________________________________________

 `-b`, `backup`

 SYNOPSIS:

 `-b {PROGRAM}`

 DESCRIPTION:	Save the current version of one or more apps, each snapshot is stored into a dedicated directory, under $HOME/.am-snapshots/$PROGRAM

 To restore the snapshots see the "-o" option.
 ___________________________________________________________________________

 `-c`, `clean`

 SYNOPSIS:

 `-c`

 DESCRIPTION:	Removes all the unnecessary files and folders.
 ___________________________________________________________________________

 `-d`, `download`

 SYNOPSIS:

 `-d {PROGRAM}`

  `-d --convert {PROGRAM}`

 DESCRIPTION:	Download one or more installation scripts to your desktop. With the option "--convert" its converted to a standalone local installer, but AM requires AppMan to be installed to add custom directory settings.
 ___________________________________________________________________________

 `-f`, `files`

 SYNOPSIS:

 `-f`

 `-f --byname`

 `-f --less`

 DESCRIPTION:	Shows the list of all installed programs, with sizes. By default apps are sorted by size, use "--byname" to sort by name. With the option "--less" it shows only the number of installed apps.
 ___________________________________________________________________________

 `-h`, `help`

 SYNOPSIS:

 `-h`

 DESCRIPTION:	Prints this message.
 ___________________________________________________________________________

 `-H`, `--home`

 SYNOPSIS:

 `-H {PROGRAM}`

 DESCRIPTION:	Set a dedicated $HOME directory for one or more AppImages.
 ___________________________________________________________________________

 `-i`, `install`

 SYNOPSIS:

 `-i {PROGRAM}`

 `-i --debug {PROGRAM}`

 `-i --force-latest {PROGRAM}`

 DESCRIPTION:   Install one or more programs or libraries from the list. With the "--debug" option you can see log messages to debug the script. For more details on "--force-latest", see the dedicated option, below.
 ___________________________________________________________________________

 `-l`, `list`

 SYNOPSIS:

 `-l`

 DESCRIPTION:	Shows the list of all the apps available in the repository.
 ___________________________________________________________________________

 `-o`, `overwrite`

 SYNOPSIS:

 `-o {PROGRAM}`

 DESCRIPTION:	Overwrite the existing version of the app with a snapshot saved previously (see the option "-b", above).
 ___________________________________________________________________________

 `-q`, `query`

 SYNOPSIS:

 `-q {KEYWORD}`

 `-q --pkg {PROGRAM1} {PROGRAM2}`

 DESCRIPTION:	Can be used to search for keywords and terms in the list of available applications packages to display matches. This can be useful if you are looking for applications having a specific feature. Add the suboption "--pkg" to search only the names of one or more apps.
 ___________________________________________________________________________

 `-r`, `remove`

 SYNOPSIS:

 `-r {PROGRAM}`

 DESCRIPTION:	Removes one or more apps, requires confirmation.
 ___________________________________________________________________________

 `-R`

 SYNOPSIS:

 `-R {PROGRAM}`

 DESCRIPTION:	Removes one or more apps without asking.
 ___________________________________________________________________________

 `-s`, `sync`

 SYNOPSIS:

 `-s`

 DESCRIPTION:	Updates this script to the latest version hosted.
 ___________________________________________________________________________

 `-t`, `template`

 SYNOPSIS:

 `-t {PROGRAM}`

 DESCRIPTION:	This option allows you to generate a custom script from a list of different templates that may be vary according to the kind of app you want to upload to the "AM" repo, and the source where it is available. You can install it using the `am test /path/to/your-script` command.
 ___________________________________________________________________________

 `-u`, `-U`, `update`

 SYNOPSIS:

 `-u`

 `-u apps`

 `-u {PROGRAM}`

 DESCRIPTION: Update all the apps (and "am" itself) or just one. If you add the "`--apps`" suboption you only update apps.
 ___________________________________________________________________________

 `-v`, `version`

 SYNOPSIS:

 `-v`

 DESCRIPTION:	Shows the version.
 ___________________________________________________________________________

 `--disable-completion`

 SYNOPSIS:

 `--disable-completion`

 DESCRIPTION:	Disable bash-completion.
 ___________________________________________________________________________

 `--enable-completion`

 SYNOPSIS:

 `--enable-completion`

 DESCRIPTION:	Enable bash-completion to complete a keyword with the "TAB" key, using the names of all installable applications available.
 ___________________________________________________________________________

 `--force-latest`

 SYNOPSIS:

 `--force-latest {PROGRAM}`

 `-i --force-latest {PROGRAM}`

 DESCRIPTION:	Downgrades an installed app from pre-release to "latest". This can be used with "-i" to force the installation of apps from "latest". Many scripts point to "releases" to find the latest build for GNU/Linux if the developer has not uploaded one in "latest".
 ___________________________________________________________________________

 `--launcher`

 SYNOPSIS:

 `--launcher /path/to/${APPIMAGE}`

 DESCRIPTION:	Embed one or more local AppImages in the applications menu. I suggest dragging the files into the terminal to get the desired effect. Launchers are located in ~/.local/share/applications/AppImages by default.
 ___________________________________________________________________________

 `--rollback`, `downgrade`

 SYNOPSIS:

 `--rollback {PROGRAM}`

 DESCRIPTION:	Download an older or specific version of the software you are interested in (only works with Github).
 ___________________________________________________________________________

 `--sandbox`

 SYNOPSIS:

 `--sandbox {PROGRAM}`

 DESCRIPTION:	Run an AppImage in a sandbox using Aisap.
 ___________________________________________________________________________

 `apikey`

 SYNOPSIS:

 `apikey {Github Token}`

 `apikey delete`

 DESCRIPTION:	Get unlimited access to https://api.github.com using your personal access tokens. The configuration file named "ghapikey.txt" will be saved in '$AMPATH' . Use the command "'$AMCLI' apikey delete/del/remove" to remove the file.
 __________________________________________________________________________

 `dev`, `devmode`

 SYNOPSIS:

 `dev off`

 `dev on`

 DESCRIPTION:	View the installer output during installation, use "on". It can be disabled with "off" or with the "`-s`" and "`-u`" options.
 __________________________________________________________________________

 `lock`

 SYNOPSIS:

 `lock {PROGRAM}`

 DESCRIPTION:	Lock the selected app to the current version installed, this only works if exists a dedicated "AM-updater" installed with the app.
 __________________________________________________________________________

 `neodb`

 SYNOPSIS:

 `neodb`

 `neodb --silent`

 DESCRIPTION:   Add third-party repos to extend the existing database. Use "--silent" to hide messages about third-party repos in use.
 __________________________________________________________________________

 `newrepo`

 SYNOPSIS:

 `newrepo {URL}`

 `newrepo off`

 `newrepo on`

 DESCRIPTION:   Set the variable "$AMREPO" to a new custom repository. Use "off" to restore the default one or overwrite it with a new one.
 __________________________________________________________________________

 `nolibfuse`

 SYNOPSIS:

 `nolibfuse {PROGRAM}`

 DESCRIPTION:   Convert an installed Type2 AppImage to a Type3 AppImage. Type3 AppImages does not require libfuse2 installed.
 __________________________________________________________________________

 `unlock`

 SYNOPSIS:

 `unlock {PROGRAM}`

 DESCRIPTION:	Unlock updates for the selected program. This option nulls the option "lock" (see above).
 ___________________________________________________________________________
 ___________________________________________________________________________

## EXTRA OPTIONS
 __________________________________________________________________________

 `--system`

 SYNOPSIS:
 
 `--system`

 DESCRIPTION:	Switch "AM" back to "AM" from "AppMan Mode" (see --user).
 __________________________________________________________________________

 `--user`, `appman`			(only available for "AM")

 SYNOPSIS:

 `--user`

 DESCRIPTION:	Run "AM" as an unprivileged user making it act as "AppMan".
 __________________________________________________________________________

</details>

------------------------------------------------------------------------

| [Install "AM"/"AppMan"](#installation) | [Back to "Main Index"](#main-index) |
| - | - |

-----------------------------------------------------------------------------

# Guides and tutorials
This section is committed to giving small demonstrations of each available option, with videos:

  - [How to install applications](#how-to-install-applications)
  - [How to list installed applications](#how-to-list-installed-applications)
  - [How to list and query all the applications available on the database](#how-to-list-and-query-all-the-applications-available-on-the-database)
  - [How to update all installed apps, modules and "AM" itself](#how-to-update-all-installed-apps-modules-and-am-itself)
  - [How to create a snapshot of an installed application](#how-to-create-a-snapshot-of-an-installed-application)
  - [How to restore an application using the already created snapshots](#how-to-restore-an-application-using-the-already-created-snapshots)
  - [How to remove one or more applications](#how-to-remove-one-or-more-applications)
  - [How to convert Type2 AppImages requiring libfuse2 to Type3 AppImages](#how-to-convert-type2-appimages-requiring-libfuse2-to-type3-appimages)
  - [How to create launchers and shortcuts for my local AppImages](#how-to-create-launchers-and-shortcuts-for-my-local-appimages)
  - [How to use "AM" in non-privileged mode, like "AppMan"](#how-to-use-am-in-non-privileged-mode-like-appman)
  - [How to sandbox an AppImage](#how-to-sandbox-an-appimage)
  - [How to enable bash completion](#how-to-enable-bash-completion)
  - [How to update or remove apps manually](#how-to-update-or-remove-apps-manually)
  - [How to downgrade an installed app to a previous version](#how-to-downgrade-an-installed-app-to-a-previous-version)
  - [Create and test your own installation script](#create-and-test-your-own-installation-script)
  - [Third-party databases for applications (NeoDB)](#third-party-databases-for-applications-neodb)

__________________________________________________________________________
### How to install applications
Option `-i` or `install`, usage:
```
am -i $PROGRAM
```
or
```
appman -i $PROGRAM
```
in this video I'll install AnyDesk and LXtask:

https://github.com/ivan-hc/AM/assets/88724353/c2e8b654-29d3-4ded-8877-f77ef11d58fc

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to list installed applications
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
### How to list and query all the applications available on the database
Options `-l` or `list` shows the whole list of apps available in this repository.

Option `-q` or `query` shows search results from the list above.

https://github.com/ivan-hc/AM/assets/88724353/2ac875df-5210-4d77-91d7-24c45eceaa2b

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to update all installed apps, modules and "AM" itself
Option `-u` or `update` updates all the installed apps and keeps "AM" in sync with the latest version and all latest bug fixes:

https://github.com/ivan-hc/AM/assets/88724353/f93ca782-2fc6-45a0-a3f2-1fba297a92bf

See "[How to update all programs, for real](#how-to-update-all-programs-for-real)".

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to create a snapshot of an installed application
Option `-b` or `backup` creates a copy of the installed app into a dedicated directory under $HOME/.am-snapshots:

https://github.com/ivan-hc/AM/assets/88724353/ae581bc0-f1c5-47da-a2c4-3d01c37cc5a4

Each snapshot is named with the date and time you have done the backup. To restore the application to a previous version, copy/paste the name of the snapshot when the `-o` option will prompt it, see "[How to restore an application using the already created snapshots](#how-to-restore-an-application-using-the-already-created-snapshots)".
__________________________________________________________________________
### How to restore an application using the already created snapshots
Option `-o` or `overwrite` lists all the snapshots you have created with the option `-o` (see above), and allows you to overwrite the new one:

https://github.com/ivan-hc/AM/assets/88724353/f9904ad2-42ec-4fce-9b21-b6b0f8a99414

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to remove one or more applications
Option `-R` removes the selected apps without asking (to have a prompt, use `-r` or `remove`):

https://github.com/ivan-hc/AM/assets/88724353/4d26d2d7-4476-4322-a0ab-a0a1ec14f751

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to convert Type2 AppImages requiring libfuse2 to Type3 AppImages
Option `nolibfuse` "just tries" to convert old Type2 AppImages asking for "libfuse2" into new Type3 AppImages:

https://github.com/ivan-hc/AM/assets/88724353/06b8e946-ef02-4678-a5a0-d8c2c24c22f9

First the selected program type is checked, if it is a Type2 AppImage, it will be extracted and repackaged using the new version of `appimagetool` from https://github.com/probonopd/go-appimage :
- if the update occurs through "comparison" of versions, the converted AppImage will be replaced by the upstream version and the command is added within the application's AM-updater script, so as to automatically start the conversion at each update (prolonging the update time, depending on the size of the AppImage);
- instead, if the installed AppImage can be updated via `zsync`, **this may no longer be updatable**.

**I suggest anyone to contact the developers to update the packaging method of their AppImage!**

NOTE, the conversion is not always successful, a lot depends on how the program is packaged. The conversion occurs in two steps:
1. if in the first case it succeeds without problems, the package will be repackaged as it was, but of Type 3;
2. if the script encounters problems (due to Appstream validation), it will attempt to delete the contents of the /usr/share/metainfo directory inside the AppImage, as a workaround.

If also the second step does not succeed either, the process will end with an error and the AppImage will remain Type2.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to create launchers and shortcuts for my local AppImages
Option `--launcher` allows you to drag/drop a local AppImage and creates the launcher (like any other classic AppImage manager, but in SHELL, so no daemons or bloated runtimes are required here) in $HOME/.local/share/applications/AppImages, also allows you to rename a symlink in $HOME/.local/bin that you can use from the command line like any other program:

https://github.com/ivan-hc/AM/assets/88724353/97c2b88d-f330-490c-970b-0f0bb89040dc

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to sandbox an AppImage
Since version 5.3 you can use the `--sandbox` option to run AppImages using a sandbox, and since version 6.12 Firejails has been dropped in favour of "[Aisap](https://github.com/mgord9518/aisap)", a [Bubblewrap](https://github.com/containers/bubblewrap) frontend for AppImages.

This method works as follows:
```
am --sandbox $APP
```
or
```
appman --sandbox $APP
```
- if the "aisap" package is not installed, you will be asked if you want to install it via "AM"/AppMan;
- requires replacing the symlink in $PATH with a script ("AM" users will need the root password);
- to work, the Appimage will be set to "not executable", and the AM-updater will also have its `chmod` command set to `a-x` instead of `a+x`.

The default location for the sandboxed homes is at $HOME/.local/am-sandboxes, but that location can be changed by setting the $SANDBOXDIR env variable.

To restore the use of the AppImage without sandbox, you need to run the application command with the "--disable-sandbox" option:
```
$APP --disable-sandbox
```
https://github.com/ivan-hc/AM/assets/88724353/420bfa1c-274f-4ac3-a79f-78ad64f01254

For more information aboit "Aisap", visit https://github.com/mgord9518/aisap

Available profiles are listed at https://github.com/mgord9518/aisap/tree/main/profiles

To learn more about permissions, see https://github.com/mgord9518/aisap/tree/main/permissions

EXTRA: The behavior of this option can be tested in a completely standalone way by consulting the repository of its creator, at [Samueru-sama/aisap-am](https://github.com/Samueru-sama/aisap-am)

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to enable bash completion
Bash completion is enabled in "AM" on first installation, while the "AppMan" one requires to be enabled manually.

For both there are two options:
- `--enabe-completion` to enable it;
- `--disable-completion` to disable it.

The file used by "AM" is "/etc/bash_completion.d/am-completion.sh", so the root password is required to use the options. The file used by "AppMan" instead is "$HOME/.bash_completion".

Both use the keywords to be completed listed within the "list" file, generated from the options list and the applications list.

https://user-images.githubusercontent.com/88724353/155971864-783c098c-e696-47b5-aaa8-85dab6ab3b46.mp4

A more detailed guide on how to create your own bash completion script for your project is available [here](https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial).

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### How to update or remove apps manually
Inside each installed applications directory, there are two scripts called "AM-updater" and "remove", and their purpose is indicated in their name:
- To update an app manually, run the AM-updater script.
- To remove an application instead, run the "remove" script (with "`sudo`" if you are an "AM" user).

__________________________________________________________________________
### How to downgrade an installed app to a previous version
Use the `--rollback` option or `downgrade` in this way:
```
am --rollback ${PROGRAM}
```
This only works with the apps hosted on Github.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](#guides-and-tutorials) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------

__________________________________________________________________________
### Create and test your own installation script
"AM"/"AppMan" has an option `-t` or `template` with which you can get a script to customize according to your needs.

The available options are as follows:

0. Create a script for an AppImage package
1. Build an AppImage on the fly using [appimagetool](https://github.com/AppImage/AppImageKit) and [pkg2appimage](https://github.com/AppImage/pkg2appimage)
2. Download and unpack a generic archive (ZIP, TAR...)
3. Create a custom Firefox profile

The currently available templates are stored [here](https://github.com/ivan-hc/AM/tree/main/templates).

![Istantanea_2024-06-17_21-35-26 png](https://github.com/ivan-hc/AM/assets/88724353/6e11aeff-9a70-44f7-bd73-1324b545704e)

In the following video you see how option 1 (formerly option 5) is able to create AppImage packages on the fly (here "Abiword" from Debian Unstable), like an AUR compiler would:

https://user-images.githubusercontent.com/88724353/150619523-a45455f6-a656-4753-93fe-aa99babc1083.mp4

A wiki is also available, here I will try to explain the installation script's workflow for a program to be better managed by "AM", trying to use a language that is as simple and elementary as possible.

Each script is written exclusively for "AM" and is structured in such a way that even "[AppMan](https://github.com/ivan-hc/AppMan)" can modify it to manage programs locally.

We can divide the stages of an installation's process as follows:

* [Step 1: create the main directory](https://github.com/ivan-hc/AM/wiki/Step-1:-create-the-main-directory) in /opt, as already suggested by the [Linux Standard Base](https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) (LSB);
* [Step 2: create the "remove" script](https://github.com/ivan-hc/AM/wiki/Step-2:-create-the-%22remove%22-script), needed to uninstall averything (this must be the first one to be created, in order to quickly resolve any aborted/brocken installations using the `-r` option);
* [Step 3: download the program](https://github.com/ivan-hc/AM/wiki/Step-3:-download-the-program) and/or compile the program (this operation varies depending on how the program is distributed);
* [Step 4: link to a $PATH](https://github.com/ivan-hc/AM/wiki/Step-4:-link-to-a-$PATH) (usually `/usr/local/bin`, but also `/usr/bin`, `/usr/games` or `/usr/local/games`);
* [Step 5: the "AM updater" script](https://github.com/ivan-hc/AM/wiki/Step-5:-the-%22AM-updater%22-script), which is a kind of "copy" of step "3" (see above) that may include options to recognize newer versions of the program. NOTE that if you intend to create a script for the fixed version of a program, you can also skip this step;
* [Step 6: launchers and icons](https://github.com/ivan-hc/AM/wiki/Step-6:-launchers-and-icons). Note that if you intend to create a script for a command line utility, you can also skip this step;
* [Step 7: change the permissions](https://github.com/ivan-hc/AM/wiki/Step-7:-permissions) in the program folder, so you can use the update function (step 5) without using "sudo" privileges
* [Step 8 (optional): your signature](https://github.com/ivan-hc/AM/wiki/Step-8-(optional):-your-signature)

The most difficult step to overcome is certainly the number "3", given the great variety of methods in which authors distribute their software, while all the other steps are much easier to overcome.

To install and test your own script, use the command `am -i /path/to/your-script` or `appman -i /path/to/your-script` depending on your CLI

__________________________________________________________________________
### Third-party databases for applications (NeoDB)
"AM"/"AppMan" can be extended by adding new application databases using a configuration file named "neodb".

For more details, see the full guide at https://github.com/ivan-hc/neodb

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
- [Wget2 prevents me from downloading apps and modules](#wget2-prevents-me-from-downloading-apps-and-modules)
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
NOTE, in AppMan you still need to use your password (`sudo`) to install the library at system level, in /usr/local/lib

Alternatively you can use the "`nolibfuse`" option to "try" to convert old Type2 AppImages to Type3, so as not to depend on `libfuse2`. In most cases it works, but sometimes it can give errors, depending on how the package was manufactured.

However, I suggest contacting the upstream developers to convince them to upgrade their packages to Type3.

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
Some developers insist on creating Appimages that create their own launcher on first launch (like WALC and OpenShot). If the official solution proposed [here](https://discourse.appimage.org/t/stop-appimage-from-asking-to-integrate/488) doesn't work, create a .home directory with the `-H` option, launch the app and accept the request. For example (with "AM"):
```
am -H walc
walc
```
Accept the integration request, the launcher will be saved in the walc.home directory located next to the AppImage file.

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------
### The script points to "releases" instead of downloading the latest stable
This is a choice I made as many developers have abandoned support for AppImage or GNU/Linux in general. My aim here is to introduce you to other developers' applications, then it's up to you to contact them, support them, help improve the software through forks and pull requests, opening issues and encouraging developers to keep the software in the format you prefer.

In case you are sure that the upstream developer will maintain the package for each stable release, you can fix this in several ways:
#### Method 1: Direct installation by combining `-d` and `-i` options
```
am -d $PROGRAM
sed -i 's#releases -O -#releases/latest -O -#g' $(xdg-user-dir DESKTOP)/$PROGRAM
am -i $(xdg-user-dir DESKTOP)/$PROGRAM
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

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](#main-index) |
| - | - |

------------------------------------------------------------------------
### Wget2 prevents me from downloading apps and modules
With the arrival of Fedora 40 in April 2024, many users began to complain about the inability to download any application from github and the inability to update modules (see https://github.com/ivan-hc/AM/issues/496). This is because "wget" is no longer actively developed, and its successor "wget2" was not yet ready to take its place immediately. Yet the Fedora team decided to replace it anyway, causing quite a few problems for this project and many others that use api.github.com to function.

Attempts to add patches to avoid having dependencies like `jq` added and to rewrite all the scripts to promptly adapt them to more versatile solutions were in vain.

So I decided to host on this repository the "wget" binaries directly from Debian 12 (see [here](https://github.com/ivan-hc/AM/tree/main/tools/x86_64) and [here](https://github.com/ivan-hc/AM/tree/main/tools/aarch64)), and the installation scripts dedicated to them, for the [x86_64](https://github.com/ivan-hc/AM/blob/main/programs/x86_64/wget) and [aarch64](https://github.com/ivan-hc/AM/blob/main/programs/x86_64/wget) architectures and which use "wget2" to download the executable.

Run the command
```
am -i wget
```
NOTE, the binary is called from a script in /usr/local/bin that runs "wget" with the "--no-check-certificate" option. It's not the best of solutions, but it's enough to suppress this shortcoming while the compatibility issue between wget and wget2 will not be completely resolved.

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
- [aisap](https://github.com/mgord9518/aisap)
- [appimagetool/go-appimage](https://github.com/probonopd/go-appimage)
- [pkg2appimage](https://github.com/AppImage/pkg2appimage)

#### My other projects
- [AppImaGen](https://github.com/ivan-hc/AppImaGen), a script that generates AppImages from Debian or from a PPA for the previous Ubuntu LTS;
- [ArchImage](https://github.com/ivan-hc/ArchImage), build AppImage packages for all distributions but including Arch Linux packages. Powered by JuNest;
- [Firefox for Linux scripts](https://github.com/ivan-hc/Firefox-for-Linux-scripts), easily install the official releases of Firefox for Linux.
- [My AppImage packages](https://github.com/ivan-hc#my-appimage-packages)

------------------------------------------------------------------------

###### *You can support me and my work on [**ko-fi.com**](https://ko-fi.com/IvanAlexHC) and [**PayPal.me**](https://paypal.me/IvanAlexHC). Thank you!*

--------

*© 2020-present Ivan Alessandro Sala aka 'Ivan-HC'* - I'm here just for fun! 

------------------------------------------------------------------------

| [**ko-fi.com**](https://ko-fi.com/IvanAlexHC) | [**PayPal.me**](https://paypal.me/IvanAlexHC) | [Install "AM"/"AppMan"](#installation) | ["Main Index"](#main-index) |
| - | - | - | - |

------------------------------------------------------------------------
