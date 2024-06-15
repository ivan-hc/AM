# "AM" Application Manager
### *Database & solutions for all AppImages and portable apps for GNU/Linux!*

------------------------------------------------------------------------
[Introducing "AM"](#introducing-am)

- [See it in action](#see-it-in-action)
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

- [Differences between "AM" and "AppMan"](#differences-between-am-and-appman)
- [Use AM locally like AppMan does](#use-am-locally-like-appman-does)
- [What programs can be installed](#what-programs-can-be-installed)
- [How to update all programs, for real](#how-to-update-all-programs-for-real)
- [Repository and Multiarchitecture](#repository-and-multiarchitecture)
- [Comparison with other AppImage managers](#comparison-with-other-appimage-managers)

[Installation](#installation)
- [Dependences](#dependences)
- [Proceed](#proceed)

[Uninstall](#uninstall)

[Usage](#usage)

[Features](#features)
- [How to enable bash completion](#how-to-enable-bash-completion)
- [Snapshots: backup your app and restore to a previous version](#snapshots-backup-your-app-and-restore-to-a-previous-version)
- [Update/remove programs without "AM"](#updateremove-programs-without-am)
- [Downgrade](#downgrade)
- [Convert old Type2 AppImages to Type3](#convert-old-type2-appimages-to-type3)
- [Manage local AppImages](#manage-local-appimages)
- [Sandbox AppImages](#sandbox-appimages)
- [Create and test your own installation script](#create-and-test-your-own-installation-script)
- [Third-party databases for applications (NeoDB)](#third-party-databases-for-applications-neodb)

[Troubleshooting](#troubleshooting)
- [An application does not work, is old and unsupported](#an-application-does-not-work-is-old-and-unsupported)
- [Cannot download or update an application](#cannot-download-or-update-an-application)
- [Cannot mount and run AppImages](#cannot-mount-and-run-appimages)
- [Spyware, malware and dangerous software](#spyware-malware-and-dangerous-software)
- [Stop AppImage prompt to create its own launcher, desktop integration and doubled launchers](#stop-appimage-prompt-to-create-its-own-launcher-desktop-integration-and-doubled-launchers)
- [The script points to "releases" instead of downloading the latest stable](#the-script-points-to-releases-instead-of-downloading-the-latest-stable)
- [Wget2 prevents me from downloading apps and modules](#wget2-prevents-me-from-downloading-apps-and-modules)
- [Wrong download link](#wrong-download-link)

[Related projects](#related-projects)

-----------------------------------------------------------------------------
# Introducing "AM"
This project is the set of two Command Line Interfaces that coexist in the same body, "[APP-MANAGER](https://github.com/ivan-hc/AM/blob/main/APP-MANAGER)". This script, depending on how it is installed and renamed, allows you to install and manage any AppImage package, but also the official versions of Firefox, Thunderbird, Brave, Blender and hundreds of other programs provided on their official sites... in the same way but with different installation methods, at system level as super user or locally. These two CLIs, or entities, are "AM" (`am` command) and "AppMan" (`appman` command), respectively.

**This repository is focused on using "AM" and contains the full database of the installation scripts for the applications managed by both "AM" and "AppMan"!**

*For specific guide on using "AppMan", see https://github.com/ivan-hc/AppMan*

Being "[APP-MANAGER](https://github.com/ivan-hc/AM/blob/main/APP-MANAGER)" a bash-based script, it can be used on all the architectures supported by the Linux kernel and works with all the GNU/Linux distributions.

"AM"/"AppMan" aims to be a merger for GNU/Linux distributions, using not just AppImage as the main package format, but also other standalone programs, so without having to risk breaking anything on your system: no daemons, no shared libraries. Just your program!

The main goal of this tool is to provide the same updated applications to multiple GNU/Linux distributions without having to change the package manager or the distro itself. This means that whatever distro you use, you will not miss your favorite programs or the need for a more updated version.

- ***You can read the common code used by both "AM" and "AppMan" at the following link***:

https://github.com/ivan-hc/AM/blob/main/APP-MANAGER

- ***You can check out updates to the common code used by both "AM" and "AppMan" at the following link***:

https://github.com/ivan-hc/AM/commits/main/APP-MANAGER

- ***For a summary of the new versions, consult the "releases" section of the "AM" repository at the following link***:

https://github.com/ivan-hc/AM/releases

------------------------------------------------------------------------
## See it in action

### How to install applications
Option `-i` or `install`, usage:
```
am -i $PROGRAM
```
in this video I'll install AnyDesk and LXtask:

https://github.com/ivan-hc/AM/assets/88724353/c2e8b654-29d3-4ded-8877-f77ef11d58fc

### How to list installed applications
Option `-f` or `files`, it shows the installed apps, the version, the size and the type of application:

https://github.com/ivan-hc/AM/assets/88724353/a11ccb22-f2fa-491f-85dd-7f9440776a54

### How to list and query all the applications available on the database
Options `-l` or `list` shows the whole list of apps available in this repository.

Option `-q` or `query` shows search results from the list above.

https://github.com/ivan-hc/AM/assets/88724353/2ac875df-5210-4d77-91d7-24c45eceaa2b

### How to update all installed apps, modules and "AM" itself
Option `-u` or `update` updates all the installed apps and keeps "AM" in sync with the latest version and all latest bug fixes:

https://github.com/ivan-hc/AM/assets/88724353/f93ca782-2fc6-45a0-a3f2-1fba297a92bf

### How to create a snapshot of an installed application
Option `-b` or `backup` creates a copy of the installed app into a dedicated directory under $HOME/.am-snapshots:

https://github.com/ivan-hc/AM/assets/88724353/ae581bc0-f1c5-47da-a2c4-3d01c37cc5a4

### How to restore an application using the already created snapshots
Option `-o` or `overwrite` lists all the snapshots you have created with the option `-o` (see above), and allows you to overwrite the new one:

https://github.com/ivan-hc/AM/assets/88724353/f9904ad2-42ec-4fce-9b21-b6b0f8a99414

### How to remove one or more applications
Option `-R` removes the selected apps without asking (to have a prompt, use `-r` or `remove`):

https://github.com/ivan-hc/AM/assets/88724353/4d26d2d7-4476-4322-a0ab-a0a1ec14f751

### How to convert Type2 AppImages requiring libfuse2 to Type3 AppImages
Option `nolibfuse` "just tries" to convert old Type2 AppImages asking for "libfuse2" into new Type3 AppImages:

https://github.com/ivan-hc/AM/assets/88724353/06b8e946-ef02-4678-a5a0-d8c2c24c22f9

### How to create launchers and shortcuts for my local AppImages
Option `--launcher` allows you to drag/drop a local AppImage and creates the launcher (like any other classic AppImage manager, but in SHELL, so no daemons or bloated runtimes are required here) in $HOME/.local/share/applications/AppImages, also allows you to rename a symlink in $HOME/.local/bin that you can use from the command line like any other program:

https://github.com/ivan-hc/AM/assets/88724353/97c2b88d-f330-490c-970b-0f0bb89040dc

### How to use "AM" in non-privileged mode, like "AppMan"
Option `--user` or `appman` allows you to use "AM" as "AppMan", to install apps locally and withour root privileges. In this video I'll install LXtask locally. To use "AM" normally again, at system level, exiting from the "AppMan Mode", use the option `--system` instead (always suggested when using "AM" as "AppMan"):

https://github.com/ivan-hc/AM/assets/88724353/65b27cf6-edc5-4a4c-b2f9-42e8623dc76f


------------------------------------------------------------------------
## Differences between "AM" and "AppMan"
<details>
  <summary></summary>

Initially the two projects traveled in parallel to each other, until version 5, in which the codes merged. However, depending on whether it is installed permanently using a specific method ("AM") or downloaded portablely ("AppMan", if renamed "`appman`") the two CLIs work slightly differently.

#### In short:

- "**AM**" applies system-wide programs integration (for all users), i.e. installs programs in the `/opt` directory (see [Linux Standard Base](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s13.html)), the launchers instead are installed in `/usr/share/applications` (or `/usr/local/share/applications` if the distribution is "immutable") with the "AM-" suffix and the links are placed in `/usr/local/bin` or `/usr/local/games`. To manage programs system wide, AM needs to be installed in `/opt/am` as "`APP-MANAGER`" with a `/usr/local/bin/am` as a symlink (see https://github.com/ivan-hc/AM#installation);
- "**AppMan**", on the other hand, works in a portable way and allows you to install and manage the same applications locally, in your "$HOME" directory, and without root privileges. However, it is important that it is renamed to `appman` to work (see https://github.com/ivan-hc/AppMan#installation)

***NOTE, "AM" can be set to work like "AppMan" using the command "`am --user`".***

#### To be more detailed, here is an overview of how apps are installed by "AM" and "AppMan"

Where `$PROGRAM` is the application we're going to install:
- "AM" (ie the `am` command) installs programs system-wide. "AM" requires the `sudo` privileges but only to install and remove the app, all the other commands can be executed as a normal user. This allows multiple users of the same system to be able to use the same installed applications. This is what an installation script installs with "AM":

      /opt/$PROGRAM/
      /opt/$PROGRAM/$PROGRAM
      /opt/$PROGRAM/AM-updater
      /opt/$PROGRAM/remove
      /opt/$PROGRAM/icons/$ICON-NAME
      /usr/local/bin/$PROGRAM
      /usr/share/applications/AM-$PROGRAM.desktop
If the distro is immutable instead, the path of the launcher (the last line above) will change like this:

      /usr/local/share/applications/AM-$PROGRAM.desktop
Since version 5.1 the installation process have introduced a check to find read-only filesystems (`grep "[[:space:]]ro[[:space:],]" /proc/mounts`), if there are mountpoints like this, your distro may be an immutable one, so an `/usr/local/share/applications` directory will be created and the installation script will be patched to redirect the installation of launchers in that path to solve the issue.

- "AppMan" (ie the `appman` command) instead does not need root privileges to work, it allows you to choose where to install your applications into your `$HOME` directory. AppMan is also usable as a portable app (i.e. you can download and place it wherever you want) and it is able to update itself, anywhere! At first start it will ask you where to install the apps and it will create the directory for you (the configuration file is in `~/.config/appman`). For example, suppose you want install everything in "Applicazioni" (the italian of "applications"), this is the structure of what an installation scripts installs with "AppMan" instead:

      ~/Applicazioni/$PROGRAM/
      ~/Applicazioni/$PROGRAM/$PROGRAM
      ~/Applicazioni/$PROGRAM/AM-updater
      ~/Applicazioni/$PROGRAM/remove
      ~/Applicazioni/$PROGRAM/icons/$ICON-NAME
      ~/.local/bin/$PROGRAM
      ~/.local/share/applications/AM-$PROGRAM.desktop

For everything else, the controls and operation are always the same for both command line tools. The only thing that changes is that the installation scripts are written only for "AM", while "AppMan" uses the same scripts and includes commands that can modify them to make them work locally during the installation process.

</details>

-----------------------------------------------------------------------------
## Use AM locally like AppMan does
<details>
  <summary></summary>

If you use "AM" and have the needing of installing apps at system level and locally, use the option `--user` that allows to run "AM" in "AppMan Mode":
```
am --user
```
To switch "AM" back to "AM" from "AppMan Mode", use the option `--system`:
```
am --system
```
To perform a test and see if you are in "AppMan Mode" or not, run for example the command `am -f` to see the list of the installed apps.

</details>

-----------------------------------------------------------------------------
## What programs can be installed
<details>
  <summary></summary>

"AM"/"AppMan" installs/removes/updates/manages only standalone programs, ie those programs that can be run from a single directory in which they are contained (where `$PROGRAM` is the name of the application, "AM" installs them always into a dedicated folder named `/opt/$PROGRAM`, while "AppMan" lets you choose to install them in a dedicated directory in your `$HOME`).

The "AM" repository aims to be a reference point where you can download all the AppImage packages scattered around the web, otherwise unobtainable, as you would expect from any package manager, through specific installation scripts for each application, as happens with the AUR PKGBUILDs, on Arch Linux. "AM" is intended to be a kind of Arch User Repository (AUR) of AppImage packages, providing them a home to stay. An both "AM" and "AppMan" are the key of this home. Visit...

# [*https://portable-linux-apps.github.io*](https://portable-linux-apps.github.io)

... for more!

### STANDALONE PROGRAMS
The programs are taken:
- from official sources (see Firefox, Thunderbird, Blender, NodeJS, Chromium Latest, Platform Tools...);
- extracted from official .deb/tar/zip packages;
- from the repositories and official sites of individual developers.

### APPIMAGES
The vast majority of scripts target AppImage packages:
- from official sources (if the upstream developers provide them);
- from AppImage recipes to be compiled on-the-fly with [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit);
- from unofficial third-party developers, but only if an official release is not available.

You can consult basic information, links to sites and sources used through the related `am -a $PROGRAM` command.

### FIREFOX PROFILES
You even create Firefox profiles to run as webapps, the ones with suffix "ffwa-" in the apps list.

### THIRD-PARTY LIBRARIES
From version 5.8 it is also possible to install [third-party libraries](https://github.com/ivan-hc/AM/tree/main/libraries) if they are not provided in your distribution's repositories.

The full list is [here](https://github.com/ivan-hc/AM/blob/main/libraries/libs-list).

</details>

-----------------------------------------------------------------------------
## How to update all programs, for real
<details>
  <summary></summary>

To update all the programs and "AM" itself, just run the command (without `sudo`):

    am -u

To update only the programs:

    am -u --apps

To update just one program:

    am -u $PROGRAM

Here are the ways in which the updates will be made:
- Updateable AppImages can rely on an [appimageupdatetool](https://github.com/AppImage/AppImageUpdate)-based "updater" or on their external zsync file (if provided by the developer);
- Non-updateable AppImages and other standalone programs will be replaced only with a more recent version if available, this will be taken by comparing the installed version with the one available on the source (using "curl", "grep" and "cat"), the same is for some AppImages created with [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit);
- Fixed versions will be listed with their build number (e.g. $PROGRAM-1.1.1). Note that most of the programs are updateable, so fixed versions will only be added upon request (or if it is really difficult to find a right wget/curl command to download the latest version).

***NOTE, with "AM", during the first installation, the main user (`$currentuser`) will take the necessary permissions on each `/opt/$PROGRAM` directory, in this way all updates will be automatic and without root permissions.***

###### *In this video I'll show you how to test an update on "Avidemux" using "AM" (I use my custom AppImage I have built from "deb-multimedia", for my use case, but don't worry, the official Avidemux AppImage is also available on this repository). Firefox, on the other hand, is not affected by this management, as it can be updated automatically*:

https://github.com/ivan-hc/AM/assets/88724353/7e1845e7-bd02-495a-a1b5-735867a765d1

</details>

-----------------------------------------------------------------------------
## Repository and Multiarchitecture
<details>
  <summary></summary>

Each program is installed through a dedicated script, and all these scripts are listed in the "[repository](https://github.com/ivan-hc/AM/tree/main/programs)" and divided by architecture.

***NOTE that currently my work focuses on applications for x86_64 architecture, but it is possible to extend "AM" to all other available architectures.***

Click on the link of your architecture to see the list of all the apps available on this repository:

- [x86_64](https://raw.githubusercontent.com/ivan-hc/AM/main/programs/x86_64-apps)
- [i686](https://raw.githubusercontent.com/ivan-hc/AM/main/programs/i686-apps)
- [aarch64](https://raw.githubusercontent.com/ivan-hc/AM/main/programs/aarch64-apps)

If you are interested, you can deliberately join this project to improve the lists above.

</details>

-----------------------------------------------------------------------------
## Comparison with other AppImage managers
<details>
  <summary></summary>

- There are many other AppImage managers around, and almost all of them support their database on appimagehub or other official AppImage resources, but the big problem is at the base of the compilation of these packages, being very often without an integrated update system. Furthermore, AppImage is a format that many developers are abandoning in favor of Flatpak, also because there were no centralized repositories or software that managed its updates in a universal way... at least until the invention of the first draft of [AppMan](https://github.com/ivan-hc/AppMan);
- With "AM"/"AppMan" each installed program has its own script (AM-updater) that compares the installed version with the one available in the sources or uses official tools to update the AppImages ([see above](#how-to-update-all-programs-for-real)), there is support for multiple architectures (including i686 and aarch64) and anyone can create a script to install that particular program (if available for its architecture).

</details>

------------------------------------------------------------------------
# Installation
### Dependences
#### *Below are the essential dependencies for both "AM" and "AppMan"!*
A warning message will prevent you from using "AM"/"AppMan" if the following packages are not installed on your system:
- "`coreutils`", is usually installed by default in all distributions as it contains basic commands ("`cat`", "`chmod`", "`chown`"...);
- "`curl`", to check URLs;
- "`grep`", to check files;
- "`jq`", to handle JSON files (some scripts need to check a download URL from api.github.com);
- "`sed`", to edit/adapt installed files;
- "`wget`" to download all programs and update "AM"/AppMan itself;

- "`sudo`" (only required by "AM")

###### *NOTE, if for some reason you don't use `sudo` and you prefer to gain administration privileges using alternative commands such as `doas` or similar, simply use "AppMan"*

<details>
  <summary>See also optional dependencies, click here!</summary>

#### *Listed below are optional dependencies that are needed only by some programs*
Don't worry, if you come across one of these programs, a message will warn you that the program cannot be installed, skipping the installation process just for that script:
- "`binutils`", contains a series of basic commands, including "`ar`" which extracts .deb packages (which are very few here);
- "`unzip`", to extract .zip packages;
- "`tar`", to extract .tar* packages;
- "`zsync`", about 10% of AppImages depend on this to be updated.

</details>

------------------------------------------------------------------------
# Proceed
"AM" is ment to be installed at system level to manage apps using `sudo` privileges.

To install "AM" quickly, just copy/paste the following command:
```
wget https://raw.githubusercontent.com/ivan-hc/AM/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL
```
Or use "GIT":
```
git clone https://github.com/ivan-hc/AM.git
cd AM
chmod a+x INSTALL
sudo ./INSTALL
```
In both cases, the "INSTALL" script will create a dedicated /opt/am directory containing the ["APP-MANAGER"](https://github.com/ivan-hc/AM/blob/main/APP-MANAGER) script (ie "AM" itself), a symlink for it in /usr/local/bin named `am` and the /opt/am/remove script needed to [uninstall](#uninstall) "AM" itself, if needed. A temporary folder named /opt/am/.cache will be created too, in wich each installation script or list of available applications (for your architecture) is downloaded.

-----------------------------------------------------------------------------
# Uninstall
Before you remove "AM"/AppMan, use the option `-R` to remove the apps installed using the following syntax (for example using "AM"):
```
am -R {PROGRAM1} {PROGRAM2} {PROGRAM3}...
```
to have a list of the installed programs use the option `-f` or `files` (syntax `am -f` or `appman -f`).

- To uninstall "AM" just run the command `am -R am`
- To uninstall "AppMan" just remove it, also remove the directory $HOME/.config/appman

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
# Features
------------------------------------------------------------------------
### How to enable bash completion
<details>
  <summary></summary>

Since 2.3.1 release "AM" has its inbuilt bash completion script that can be enabled using the following command:

    am --enable-completion
This will ceate a bash completion script in /etc/bash_completion.d named `am-completion.sh` needed to complete a keyword with the TAB key using the names of all the main options and the name of the scripts of all the applications available in the "AM" repository.
To disable bash completion (and to remove the /etc/bash_completion.d/am-completion.sh script):

    am --disable-completion
Here you are a video on how to disable/enable bash completion in "AM":

https://user-images.githubusercontent.com/88724353/155971864-783c098c-e696-47b5-aaa8-85dab6ab3b46.mp4

A more detailed guide on how to create your own bash completion script for your project is available [here](https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial).

</details>

------------------------------------------------------------------------
### Snapshots: backup your app and restore to a previous version
<details>
  <summary></summary>

Since 2.6.1 release, "AM" supports snapshots of all installed applications. A selected program can be copied locally into your home folder.

Here you are a video on how to backup/restore works in "AM":

https://user-images.githubusercontent.com/88724353/157094646-0e29ddbe-6cb7-4880-8414-110db071e617.mp4

- option `-b` or `backup` creates the snapshot, usage:

      am -b $PROGRAM
- option `-o` or `overwrite` allows you to roll back to a previous version of the program. Usage:

      am -o $PROGRAM
All the snapshots are stored into an hidden `/home/$USER/.am-snapshots` folder containing other subfolders, each one has the name of the programs you've done a backup before. Each snapshot is named with the date and time you have done the backup. To restore the application to a previous version, copy/paste the name of the snapshot when the `-o` option will prompt it.

</details>

------------------------------------------------------------------------
### Update/remove programs without "AM"
<details>
  <summary></summary>

- To update a program without "am":
```
/opt/$PROGRAM/AM-updater
```
Note that this works only if the program has a /opt/$PROGRAM/AM-updater script, other programs like Firefox and Thunderbird are auto-updatable.

- To uninstall a program without "am":
```
sudo /opt/$PROGRAM/remove
```

</details>

------------------------------------------------------------------------
### Downgrade
<details>
  <summary></summary>

From version 4.4 it is possible to directly select from a list of URLs the version of the app that interests you most from the main source. Use the `--rollback` option or `downgrade` in this mode:
```
am --rollback ${PROGRAM}
```
This only works with the apps hosted on Github.

</details>

------------------------------------------------------------------------
### Convert old Type2 AppImages to Type3
<details>
  <summary></summary>

Since version 6.1 it is possible to convert old Type2 AppImages (dependent on `libfuse2`) to Type3 using the option `nolibfuse`.
```
am nolibfuse ${PROGRAM}
```
First the selected program type is checked, if it is a Type2 AppImage, it will be extracted and repackaged using the new version of `appimagetool` from https://github.com/probonopd/go-appimage :
- if the update occurs through "comparison" of versions, the converted AppImage will be replaced by the upstream version and the command is added within the application's AM-updater script, so as to automatically start the conversion at each update (prolonging the update time, depending on the size of the AppImage);
- instead, if the installed AppImage can be updated via `zsync`, **this may no longer be updatable**.

**I suggest anyone to contact the developers to update the packaging method of their AppImage!**

NOTE, the conversion is not always successful, a lot depends on how the program is packaged. The conversion occurs in two steps:
- if in the first case it succeeds without problems, the package will be repackaged as it was, but of Type 3;
- if the script encounters problems (due to Appstream validation), it will attempt to delete the contents of the /usr/share/metainfo directory inside the AppImage, as a workaround;
- if this step does not succeed either, the process will end with an error and the AppImage will remain Type2.

</details>

------------------------------------------------------------------------
### Manage local AppImages
<details>
  <summary></summary>

Since version 4.4.2 you can use the `--launcher` option to integrate your local AppImage packages by simply dragging and dropping them into the terminal (see video).

https://github.com/ivan-hc/AM/assets/88724353/c4b889f4-8504-4853-8918-44d52084fe6c

</details>

------------------------------------------------------------------------
### Sandbox AppImages
<details>
  <summary></summary>

Since version 5.3 you can use the `--sandbox` option to run AppImages using a sandbox, and since version 6.12 Firejails has been dropped in favour of "[Aisap](https://github.com/mgord9518/aisap)"!

This method works as follows:
```
am --sandbox $APP
```
or
```
appman --sandbox $APP
```
- if the "aisap" package is not installed, you will be asked if you want to install it via "AM"/AppMan;
- requires replacing the symlink in $PATH with a script;
- to work, the Appimage will be set to "not executable", and the AM-updater will also have its `chmod` command set to `a-x` instead of `a+x`.

To restore the use of the AppImage without sandbox, you need to run the application command with the "--disable-sandbox" option:
```
$APP --disable-sandbox
```
NOTE, "AM" users will need to use the root password to replace the symlink in $PATH with the script, while AppMan users will need to close the terminal for the changes to take effect.

</details>

------------------------------------------------------------------------
### Create and test your own installation script
<details>
  <summary></summary>

"AM"/"AppMan" has a `-t` option (or `template`) with which you can get a script to customize according to your needs. With this option, you can quickly create scripts to download existing programs or even create AppImage or AppDirs through tools such as [appimagetool](https://github.com/AppImage/AppImageKit) and [pkg2appimage](https://github.com/AppImage/pkg2appimage).

The following video shows how to create and test an AppImage of "Abiword" from Debian Unstable repository with a custom AppRun (option 5):

https://user-images.githubusercontent.com/88724353/150619523-a45455f6-a656-4753-93fe-aa99babc1083.mp4

The currently available templates are stored [here](https://github.com/ivan-hc/AM/tree/main/templates).

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

</details>

------------------------------------------------------------------------
# Third-party databases for applications (NeoDB)
<details>
  <summary></summary>

From version 6.4, "AM"/"AppMan" can be extended by adding new application databases using a configuration file named "neodb".

### For more details, see the full guide at https://github.com/ivan-hc/neodb

</details>

------------------------------------------------------------------------
-----------------------------------------------------------------------------
# Troubleshooting
-----------------------------------------------------------------------------
### An application does not work, is old and unsupported
<details>
  <summary></summary>

Use the `-a` option and go to the developer's site to report the problem. The task of "AM" is solely to install / remove / update the applications managed by it. Problems related to the failure of an installed program or any related bugs are attributable solely to its developers.

</details>

-----------------------------------------------------------------------------
### Cannot download or update an application
<details>
  <summary></summary>

There can be many reasons:
- check your internet connection;
- if the app is hosted on github.com, you have probably exceeded the hourly limit of API calls;
- the referring link may have been changed, try the `--rollback` option or `downgrade`;
- the reference site has changed, report any changes at https://github.com/ivan-hc/AM/issues

</details>

-----------------------------------------------------------------------------
### Cannot mount and run AppImages
<details>
  <summary></summary>

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

</details>

-----------------------------------------------------------------------------
### Spyware, malware and dangerous software
<details>
  <summary></summary>

Before installing any application, try to know where it comes from first. This program provides you with two basic options for this purpose:
- Option `-a` or `about` (medium safety), allows you to read a short description and know the links from the pages of the site [https://portable-linux-apps.github.io](https://portable-linux-apps.github.io) locally, however these links may be inaccurate due to continuous updates of the initial scripts (you can provide additional info yourself by modifying the pages of the site, [here](https://github.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io), it is also open source);
- Option `-d` or `download` (absolute safety), this allows you to get the installation script directly on your desktop, so you can read the mechanisms and how it performs the downloads from the sources (in most cases there is a header for each step that explains what the listed commands do).

“AM” and AppMan are just tools to easily install all listed programs, but what you choose to install is your complete responsibility. **Use at your own risk**!

</details>

-----------------------------------------------------------------------------
### Stop AppImage prompt to create its own launcher, desktop integration and doubled launchers
<details>
  <summary></summary>

Some developers insist on creating Appimages that create their own launcher on first launch (like WALC and OpenShot). If the official solution proposed [here](https://discourse.appimage.org/t/stop-appimage-from-asking-to-integrate/488) doesn't work, create a .home directory with the `-H` option, launch the app and accept the request. For example (with "AM"):
```
am -H walc
walc
```
Accept the integration request, the launcher will be saved in the walc.home directory located next to the AppImage file.

</details>

-----------------------------------------------------------------------------
### The script points to "releases" instead of downloading the latest stable
<details>
  <summary></summary>

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

</details>

------------------------------------------------------------------------
### Wget2 prevents me from downloading apps and modules
<details>
  <summary></summary>

With the arrival of Fedora 40 in April 2024, many users began to complain about the inability to download any application from github and the inability to update modules (see https://github.com/ivan-hc/AM/issues/496). This is because "wget" is no longer actively developed, and its successor "wget2" was not yet ready to take its place immediately. Yet the Fedora team decided to replace it anyway, causing quite a few problems for this project and many others that use api.github.com to function.

Attempts to add patches to avoid having dependencies like `jq` added and to rewrite all the scripts to promptly adapt them to more versatile solutions were in vain.

So I decided to host on this repository the "wget" binaries directly from Debian 12 (see [here](https://github.com/ivan-hc/AM/tree/main/tools/x86_64) and [here](https://github.com/ivan-hc/AM/tree/main/tools/aarch64)), and the installation scripts dedicated to them, for the [x86_64](https://github.com/ivan-hc/AM/blob/main/programs/x86_64/wget) and [aarch64](https://github.com/ivan-hc/AM/blob/main/programs/x86_64/wget) architectures and which use "wget2" to download the executable.

Run the command
```
am -i wget
```
NOTE, the binary is called from a script in /usr/local/bin that runs "wget" with the "--no-check-certificate" option. It's not the best of solutions, but it's enough to suppress this shortcoming while the compatibility issue between wget and wget2 will not be completely resolved.

</details>

------------------------------------------------------------------------
### Wrong download link
<details>
  <summary></summary>

The reasons may be two:
- the referring link may have been changed, try the `--rollback` option or `downgrade`;
- the reference site has changed, report any changes at https://github.com/ivan-hc/AM/issues

</details>

------------------------------------------------------------------------
------------------------------------------------------------------------
# Related projects
#### External tools and forks used in this project
- [appimagetool](https://github.com/AppImage/AppImageKit)
- [appimageupdatetool](https://github.com/AppImage/AppImageUpdate)
- [libunionpreload](https://github.com/project-portable/libunionpreload)
- [pkg2appimage](https://github.com/AppImage/pkg2appimage)

#### My other projects
- [AppImaGen](https://github.com/ivan-hc/AppImaGen), a script that generates AppImages from Debian or from a PPA for the previous Ubuntu LTS;
- [ArchImage](https://github.com/ivan-hc/ArchImage), build AppImage packages for all distributions but including Arch Linux packages. Powered by JuNest;
- [Firefox for Linux scripts](https://github.com/ivan-hc/Firefox-for-Linux-scripts), easily install the official releases of Firefox for Linux.

------------------------------------------------------------------------

###### *You can support me and my work on [**ko-fi.com**](https://ko-fi.com/IvanAlexHC) and [**PayPal.me**](https://paypal.me/IvanAlexHC). Thank you!*

--------

*© 2020-present Ivan Alessandro Sala aka 'Ivan-HC'* - I'm here just for fun! 

