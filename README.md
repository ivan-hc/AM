# "AM" Application Manager
### *Database & solutions for all AppImages and portable apps for GNU/Linux!*

------------------------------------------------------------------------
[Introducing "AM"](#introducing-am)
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
- [Install/update/remove programs without "AM"](#installupdateremove-programs-without-am)
- [Rollback](#rollback)
- [Manage local AppImages](#manage-local-appimages)
- [Sandbox using Firejail](#sandbox-using-firejail)
- [Create and test your own installation script](#create-and-test-your-own-installation-script)

[Troubleshooting](#troubleshooting)
- [An application does not work, is old and unsupported](#an-application-does-not-work-is-old-and-unsupported)
- [Cannot download or update an application](#cannot-download-or-update-an-application)
- [Cannot mount and run AppImages](#cannot-mount-and-run-appimages)
- [Spyware, malware and dangerous software](#spyware-malware-and-dangerous-software)
- [Stop AppImage prompt to create its own launcher, desktop integration and doubled launchers](#stop-appimage-prompt-to-create-its-own-launcher-desktop-integration-and-doubled-launchers)
- [Wrong download link](#wrong-download-link)

[Related projects](#related-projects)

-----------------------------------------------------------------------------
# Introducing "AM"
This project is the set of two Command Line Interfaces that coexist in the same body, "[APP-MANAGER](https://github.com/ivan-hc/AM-Application-Manager/blob/main/APP-MANAGER)". This script, depending on how it is installed and renamed, allows you to install and manage any AppImage package, but also the official versions of Firefox, Thunderbird, Brave, Blender and hundreds of other programs provided on their official sites... in the same way but with different installation methods, at system level as super user or locally. These two CLIs, or entities, are "AM" (`am` command) and "AppMan" (`appman` command), respectively.

**This repository is focused on using "AM" and contains the full database of the installation scripts for the applications managed by both "AM" and "AppMan"!**

*For specific guide on using "AppMan", see https://github.com/ivan-hc/AppMan*

*See it in action ("AM" version 4.3.2):*

https://github.com/ivan-hc/AM-Application-Manager/assets/88724353/b2dd8ca6-5ee7-4bb2-8480-9a53f5cfcf56

Being "[APP-MANAGER](https://github.com/ivan-hc/AM-Application-Manager/blob/main/APP-MANAGER)" a bash-based script, it can be used on all the architectures supported by the Linux kernel and works with all the GNU/Linux distributions.

"AM"/"AppMan" aims to be a merger for GNU/Linux distributions, using not just AppImage as the main package format, but also other standalone programs, so without having to risk breaking anything on your system: no daemons, no shared libraries. Just your program!

The main goal of this tool is to provide the same updated applications to multiple GNU/Linux distributions without having to change the package manager or the distro itself. This means that whatever distro you use, you will not miss your favorite programs or the need for a more updated version.

- ***You can read the common code used by both "AM" and "AppMan" at the following link***:

https://github.com/ivan-hc/AM-Application-Manager/blob/main/APP-MANAGER

- ***You can check out updates to the common code used by both "AM" and "AppMan" at the following link***:

https://github.com/ivan-hc/AM-Application-Manager/commits/main/APP-MANAGER

- ***For a summary of the new versions, consult the "releases" section of the "AM" repository at the following link***:

https://github.com/ivan-hc/AM-Application-Manager/releases

------------------------------------------------------------------------
## Differences between "AM" and "AppMan"
<details>
  <summary></summary>

Initially the two projects traveled in parallel to each other, until version 5, in which the codes merged. However, depending on whether it is installed permanently using a specific method ("AM") or downloaded portablely ("AppMan", if renamed "`appman`") the two CLIs work slightly differently.

#### In short:

- "**AM**" applies system-wide programs integration (for all users), i.e. installs programs in the `/opt` directory (see [Linux Standard Base](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s13.html)), the launchers instead are installed in `/usr/share/applications` (or `/usr/local/share/applications` if the distribution is "immutable") with the "AM-" suffix and the links are placed in `/usr/local/bin` or `/usr/local/games`. To manage programs system wide, AM needs to be installed in `/opt/am` as "`APP-MANAGER`" with a `/usr/local/bin/am` as a symlink (see https://github.com/ivan-hc/AM-Application-Manager#installation);
- "**AppMan**", on the other hand, works in a portable way and allows you to install and manage the same applications locally, in your "$HOME" directory, and without root privileges. However, it is important that it is renamed to `appman` to work (see https://github.com/ivan-hc/AppMan#installation)

***NOTE, "AM" can be set to work like "AppMan" by enabling an alias provided with the command "`am --user`".***

#### To be more detailed, here is an overview of how apps are installed by "AM" and "AppMan"

Where `$PROGRAM` is the application we're going to install:
- "AM" (ie the `am` command) installs programs and works at system level (i.e. for all the users). "AM" requires the `sudo` privileges but only to install and remove the app, all the other commands can be executed as a normal user. This allows multiple users of the same system to be able to use the same installed applications. This is what an installation script installs with "AM":

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

If you usa "AM" and have the needing of installing apps at system level and locally, use the option `--user` that allows you to create an alias to install and manage apps in your $HOME folder. When executing the `am --user` command you will be suggested an alias to use temporarily or if you want you can add it in your ~/.bashrc to make it permanent. "AppMan" will be used while still using the usual `am` command.

The `--user` option does not immediately enable "AppMan Mode", instead it will show you an alias to use temporarily in the current session or to add to your ~/.bashrc to make it permanent:
```
alias am=/opt/am/appman
```
AppMan is downloaded to the AM's installation folder, but without affecting the existing installation.

***NOTE: using AM with the `--user` option enabled and the alias for AppMan, "sudo" allows normal use of AM, absence allows use of AppMan.***

</details>

-----------------------------------------------------------------------------
## What programs can be installed
<details>
  <summary></summary>

"AM"/"AppMan" installs/removes/updates/manages only standalone programs, ie those programs that can be run from a single directory in which they are contained (where `$PROGRAM` is the name of the application, "AM" installs them always into a dedicated folder named `/opt/$PROGRAM`, while "AppMan" lets you choose to install them in a dedicated directory in your `$HOME`).

These programs are taken:
- from official sources (see Firefox, Thunderbird, Blender, NodeJS, Chromium Latest, Platform Tools...);
- from official .deb packages;
- from the repositories and official sites of individual developers;
- from tar archives of other GNU/Linux distributions;
- from AUR or other Arch Linux-related sources;
- from AppImage recipes to be compiled with [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit);
- from unofficial repositories of developers external to the project concerned (most of the time they are programs in AppImage format), but only if an official release is not available (see the various WINE, Zoom, VLC, GIMP, OBS Studio...).

"AM"/"AppMan" can even create Firefox profiles to run as webapps (as an alternative to the countless Electron-based apps/AppImages)!

You can consult basic information, links to sites and sources used through the related `am -a $PROGRAM` command or by connecting to the main site of this project:

# [*https://portable-linux-apps.github.io*](https://portable-linux-apps.github.io)

The "AM" repository aims to be a reference point where you can download all the AppImage packages scattered around the web, otherwise unobtainable, as you would expect from any package manager, through specific installation scripts for each application, as happens with the AUR PKGBUILDs, on Arch Linux. "AM" is intended to be a kind of Arch User Repository (AUR) of AppImage packages, providing them a home to stay. An both "AM" and "AppMan" are the key of this home.

</details>

-----------------------------------------------------------------------------
## How to update all programs, for real
<details>
  <summary></summary>

To update all the programs, just run the command (without `sudo`):

    am -u
    
To update just one program:

    am -u $PROGRAM

Here are the ways in which the updates will be made:
- Updateable AppImages can rely on an [appimageupdatetool](https://github.com/AppImage/AppImageUpdate)-based "updater" or on their external zsync file (if provided by the developer);
- Non-updateable AppImages and other standalone programs will be replaced only with a more recent version if available, this will be taken by comparing the installed version with the one available on the source (using "curl", "grep" and "cat"), the same is for some AppImages created with [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit);
- Fixed versions will be listed with their build number (e.g. $PROGRAM-1.1.1). Note that most of the programs are updateable, so fixed versions will only be added upon request (or if it is really difficult to find a right wget/curl command to download the latest version).

***NOTE, with "AM", during the first installation, the main user (`$currentuser`) will take the necessary permissions on each `/opt/$PROGRAM` directory, in this way all updates will be automatic and without root permissions.***

###### *In this video I'll show you how to test an update on "Avidemux" using "AM" (I use my custom AppImage I have built from "deb-multimedia", for my use case, but don't worry, the official Avidemux AppImage is also available on this repository). Firefox, on the other hand, is not affected by this management, as it can be updated automatically*:

https://github.com/ivan-hc/AM-Application-Manager/assets/88724353/7e1845e7-bd02-495a-a1b5-735867a765d1

</details>

-----------------------------------------------------------------------------
## Repository and Multiarchitecture
<details>
  <summary></summary>

Each program is installed through a dedicated script, and all these scripts are listed in the "[repository](https://github.com/ivan-hc/AM-application-manager/tree/main/programs)" and divided by architecture.

***NOTE that currently my work focuses on applications for x86_64 architecture, but it is possible to extend "AM" to all other available architectures.***

Click on the link of your architecture to see the list of all the apps available on this repository:

- [x86_64](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/x86_64-apps)
- [i686](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/i686-apps)
- [aarch64](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/aarch64-apps)

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
wget https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL
```
Or use "GIT":
```
git clone https://github.com/ivan-hc/AM-application-manager.git
cd AM-application-manager
chmod a+x INSTALL
sudo ./INSTALL
```    
In both cases, the "INSTALL" script will create a dedicated /opt/am directory containing the ["APP-MANAGER"](https://github.com/ivan-hc/AM-application-manager/blob/main/APP-MANAGER) script (ie "AM" itself), a symlink for it in /usr/local/bin named `am` and the /opt/am/remove script needed to [uninstall](#uninstall) "AM" itself, if needed. A temporary folder named /opt/am/.cache will be created too, in wich each installation script or list of available applications (for your architecture) is downloaded.

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
 
 DESCRIPTION:	Download one or more installation scripts to your desktop.
 ___________________________________________________________________________
 
 `-f`, `files`
 
 SYNOPSIS:

 `-f`
 
 DESCRIPTION:	Shows the list of all installed programs, with sizes.
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
 
 DESCRIPTION:	Install one or more programs.
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
 
 DESCRIPTION:	Can be used to search for keywords and terms in the list of available applications packages to display matches. This can be useful if you are looking for applications having a specific feature.
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
 
 `-u {PROGRAM}`
 		
 DESCRIPTION: Update all the apps or just one.
 ___________________________________________________________________________
 
 `-v`, `version`
 
 SYNOPSIS:

 `-v`
 
 DESCRIPTION:	Shows the version.
 ___________________________________________________________________________
 
 `-w`, `web`
 
 SYNOPSIS:

 `-w`
 
 DESCRIPTION:	Shows the URLs of the sites/sources of then app.
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
 
 `--firejail`, `--sandbox`
 
 SYNOPSIS:

 `--firejail {PROGRAM}`
 
 DESCRIPTION:	Run an AppImage in a sandbox using Firejail.
 ___________________________________________________________________________

 `--launcher`
 
 SYNOPSIS:
 
 `--launcher /path/to/${APPIMAGE}`

 DESCRIPTION:	Embed one or more local AppImages in the applications menu. I suggest dragging the files into the terminal to get the desired effect. Launchers are located in ~/.local/share/applications/AppImages by default.
 ___________________________________________________________________________
 
 `--rollback`
 
 SYNOPSIS:

 `--rollback {PROGRAM}`
 
 DESCRIPTION:	Download an older or specific version of the software you are interested in (only works with Github).
 ___________________________________________________________________________ 
 
 `apikey`
 
 SYNOPSIS:	`apikey {Github Token}`
 		`apikey delete`
 
 DESCRIPTION:	Get unlimited access to https://api.github.com using your personal access tokens. The configuration file named "ghapikey.txt" will be saved in '$AMPATH' . Use the command "'$AMCLI' apikey delete/del/remove" to remove the file.
 __________________________________________________________________________
 
 `dev`, `devmode`
 
 SYNOPSIS:	`dev off`
 		`dev on`
 
 DESCRIPTION:	View the installer output during installation, use "on". It can be disabled with "off" or with the "`-s`" and "`-u`" options.
 __________________________________________________________________________ 
 
 `lock`
 
 SYNOPSIS:

 `lock {PROGRAM}`
 
 DESCRIPTION:	Lock the selected app to the current version installed, this only works if exists a dedicated "AM-updater" installed with the app.
 __________________________________________________________________________
 
 `test`
 
 SYNOPSIS:	`test {FILE}`
 
 DESCRIPTION:	Install a local installation script, or test your own.
 __________________________________________________________________________
 
 `unlock`
 
 SYNOPSIS:

 `unlock {PROGRAM}`
 
 DESCRIPTION:	Unlock updates for the selected program. This option nulls the option "lock" (see above).
 ___________________________________________________________________________
 ___________________________________________________________________________

## EXTRA OPTIONS
 ___________________________________________________________________________

 `conv`, `convert`			 (only available for "APPMAN")
 
 SYNOPSIS:

 `conv {PROGRAM}`
 
 DESCRIPTION:	Downloads the installation scripts for "AM" and converts them to rootless installation scripts that can be installed locally. 
 ___________________________________________________________________________ 
 
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
### Install/update/remove programs without "AM"
<details>
  <summary></summary>

"AM" focuses a lot on the autonomy of its programs, so much that you can install, update and remove them without necessarily having "AM" installed on your system.
- To install a program without "am", replace "SAMPLE" at the line 2 with the name of the program you want to install:
```
ARCH=$(uname -m)
PROGRAM=SAMPLE
wget https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/$ARCH/$PROGRAM
chmod a+x ./$PROGRAM
 sudo ./$PROGRAM
```
- To update a program without "am" instead, just run:
```
/opt/$PROGRAM/AM-updater
```
Note that this works only if the program has a /opt/$PROGRAM/AM-updater script, other programs like Firefox and Thunderbird are auto-updatable. 
	
- To uninstall a program without "am":
```
sudo /opt/$PROGRAM/remove
```

***NOTE, to do the same thing but locally, without `sudo`, you must necessarily use "AppMan". Installation scripts are written for system-wide installation only. To convert them to AppMan style installation scripts use the `appman convert {PROGRAM}` command to download and patch them.***

</details>

------------------------------------------------------------------------
### Rollback
<details>
  <summary></summary>

From version 4.4 it is possible to directly select from a list of URLs the version of the app that interests you most from the main source. Use the `--rollback` option in this mode:
```
am --rollback ${PROGRAM}
```
This only works with the apps hosted on Github.

</details>

------------------------------------------------------------------------
### Manage local AppImages
<details>
  <summary></summary>

Since version 4.4.2 you can use the `--launcher` option to integrate your local AppImage packages by simply dragging and dropping them into the terminal (see video).

https://github.com/ivan-hc/AM-Application-Manager/assets/88724353/c4b889f4-8504-4853-8918-44d52084fe6c

</details>

------------------------------------------------------------------------
### Sandbox using Firejail
<details>
  <summary></summary>

Since version 5.3 you can use the `--firejail` option to run AppImages using a sandbox (requires Firejail installed on the host).

At first start a copy of /etc/firejail/default.profile will be saved in your application's directory, so you're free to launch the AppImage once using the default Firejail profile (option 1) or the custom one (2), you can also patch the .desktop files (if available) to in sandbox-mode always (options 3 and 4). You can handle the custom firejail.profile file of the app using `vim` or `nano` using the option 5 (the first selection is `vim`).

Options 1, 2 and 5 are continuous to let you edit the file and test your changes immediately. Press any key to exit.

NOTE: once patched the .desktop files (options 3 and 4), they will be placed in ~/.local/share/applications, this means that if you have installed apps using AppMan, the original launchers will be overwrited.

</details>

------------------------------------------------------------------------
### Create and test your own installation script
<details>
  <summary></summary>

"AM"/"AppMan" has a `-t` option (or `template`) with which you can get a script to customize according to your needs. With this option, you can quickly create scripts to download existing programs or even create AppImage or AppDirs through tools such as [appimagetool](https://github.com/AppImage/AppImageKit) and [pkg2appimage](https://github.com/AppImage/pkg2appimage).

The following video shows how to create and test an AppImage of "Abiword" from Debian Unstable repository with a custom AppRun (option 5):

https://user-images.githubusercontent.com/88724353/150619523-a45455f6-a656-4753-93fe-aa99babc1083.mp4

The currently available templates are stored [here](https://github.com/ivan-hc/AM-application-manager/tree/main/templates).

A wiki is also available, here I will try to explain the installation script's workflow for a program to be better managed by "AM", trying to use a language that is as simple and elementary as possible.

Each script is written exclusively for "AM" and is structured in such a way that even "[AppMan](https://github.com/ivan-hc/AppMan)" can modify it to manage programs locally.

We can divide the stages of an installation's process as follows:

* [Step 1: create the main directory](https://github.com/ivan-hc/AM-Application-Manager/wiki/Step-1:-create-the-main-directory) in /opt, as already suggested by the [Linux Standard Base](https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) (LSB);
* [Step 2: create the "remove" script](https://github.com/ivan-hc/AM-Application-Manager/wiki/Step-2:-create-the-%22remove%22-script), needed to uninstall averything (this must be the first one to be created, in order to quickly resolve any aborted/brocken installations using the `-r` option);
* [Step 3: download the program](https://github.com/ivan-hc/AM-Application-Manager/wiki/Step-3:-download-the-program) and/or compile the program (this operation varies depending on how the program is distributed);
* [Step 4: link to a $PATH](https://github.com/ivan-hc/AM-Application-Manager/wiki/Step-4:-link-to-a-$PATH) (usually `/usr/local/bin`, but also `/usr/bin`, `/usr/games` or `/usr/local/games`);
* [Step 5: the "AM updater" script](https://github.com/ivan-hc/AM-Application-Manager/wiki/Step-5:-the-%22AM-updater%22-script), which is a kind of "copy" of step "3" (see above) that may include options to recognize newer versions of the program. NOTE that if you intend to create a script for the fixed version of a program, you can also skip this step;
* [Step 6: launchers and icons](https://github.com/ivan-hc/AM-Application-Manager/wiki/Step-6:-launchers-and-icons). Note that if you intend to create a script for a command line utility, you can also skip this step;
* [Step 7: change the permissions](https://github.com/ivan-hc/AM-Application-Manager/wiki/Step-7:-permissions) in the program folder, so you can use the update function (step 5) without using "sudo" privileges
* [Step 8 (optional): your signature](https://github.com/ivan-hc/AM-Application-Manager/wiki/Step-8-(optional):-your-signature)

The most difficult step to overcome is certainly the number "3", given the great variety of methods in which authors distribute their software, while all the other steps are much easier to overcome.

To install and test your own script, use the command `am test /path/to/your-script` or `appman test /path/to/your-script` depending on your CLI, this way:

https://github.com/ivan-hc/AM-Application-Manager/assets/88724353/fa0e8627-6beb-47fc-a52f-0d32e392c7ce

</details>

-----------------------------------------------------------------------------
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
- the referring link may have been changed, try the `--rollback` option;
- the reference site has changed, report any changes at https://github.com/ivan-hc/AM-Application-Manager/issues

</details>

-----------------------------------------------------------------------------
### Cannot mount and run AppImages
<details>
  <summary></summary>

See https://docs.appimage.org/user-guide/troubleshooting/fuse.html

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
### Wrong download link
<details>
  <summary></summary>

The reasons may be two:
- the referring link may have been changed, try the `--rollback` option;
- the reference site has changed, report any changes at https://github.com/ivan-hc/AM-Application-Manager/issues
### Stop AppImage prompt to create its own launcher, desktop integration and doubled launchers
Some developers insist on creating Appimages that create their own launcher on first launch (like WALC and OpenShot). If the official solution proposed [here](https://discourse.appimage.org/t/stop-appimage-from-asking-to-integrate/488) doesn't work, create a .home directory with the `-H` option, launch the app and accept the request. For example (with "AM"):
```
am -H walc
walc
```
Accept the integration request, the launcher will be saved in the walc.home directory located next to the AppImage file.

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

*© 2020-present Ivan Alesandro Sala aka 'Ivan-HC'* - I'm here just for fun! 
