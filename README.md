# "AM" the Application Manager for GNU/Linux
#### Why a new package manager?
Many programs for GNU/Linux can work without necessarily having to mix their libraries with other programs in a completely standalone way (AppImage, but also other autonomous applications, such as Firefox, Blender and Thunderbird). The only thing they needed was a tool that could download, install, and manage them... so I thought about writing not one but two: "AM" and "AppMan".

------------------------------------------------------------------------
[Introducing "AM"](#introducing-am)
- [Differences between "AM" and "AppMan"](#differences-between-am-and-appman)
- [What programs can be installed](#what-programs-can-be-installed)
- [How to update all programs, for real](#how-to-update-all-programs-for-real)
- [Repository and Multiarchitecture](#repository-and-multiarchitecture)
- [Comparison with other package managers](#comparison-with-other-package-managers)

[Installation](#installation)

[Usage](#usage)

[Features](#features)
- [How to enable bash completion](#how-to-enable-bash-completion)
- [Snapshots: backup your app and restore to a previous version](#snapshots-backup-your-app-and-restore-to-a-previous-version)
- [Install/update/remove programs without "AM"](#installupdateremove-programs-without-am)

[Create your own script](#create-your-own-script)

[Uninstall](#uninstall)

[Known issues](#known-issues)

[Related projects](#related-projects)

[Conclusions](#conclusions)

-----------------------------------------------------------------------------
# Introducing "AM"
AM is an application manager for AppImages and other standalone programs for GNU/Linux with multi-architecture support. The "am" command is very easy to use and can manage a better control of automatic updates for all the programs installed.

The main goal of this tool is to provide the same updated applications to multiple GNU/Linux distributions without having to change the package manager or the distro itself. This means that whatever distro you use, you will not miss your favorite programs or the need for a more updated version.

"AM" also aims to be a merger for GNU/Linux distributions, using not just AppImage as the main package format, but also other standalone programs, so without having to risk breaking anything on your system: no daemons, no shared libraries. Just your program!
 
https://user-images.githubusercontent.com/88724353/150169396-7f215547-e7ee-4e3b-becc-848f341ba8b3.mp4

-----------------------------------------------------------------------------
## Differences between "AM" and "AppMan"
"AM" and "AppMan" are two command line tools that can download, install, update, remove and save AppImage and other standalone applications trying to always get the original versions from the main sources, and where necessary, try to create AppImage using [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit). Since March 2022 "AM" provides its source code as the base for the newer releases of AppMan, making it a version of "AM" that allows you to install programs locally instead. 

Where `$PROGRAM` is the application we're going to install:
- "AM" (ie the `am` command, provided by this main repository) installs programs and all related files into a `/opt/$PROGRAM` directory, the launcher in `/usr/share/applications` and the main application link in a`$PATH` (i.e. `/usr/local/bin` or `/usr/games`), this allows multiple users of the same system to be able to use the same installed applications. Root privileges (`sudo`) are required only to install and remove applications;
- "AppMan" (ie the `appman` command, available at [github.com/ivan-hc/AppMan](https://github.com/ivan-hc/AppMan)) instead does not need root privileges to work, programs and all related files into a local directory named `~/.opt/$PROGRAM`, the launcher is placed into the `~/.local/share/applications` directory and the main application link is placed into a new `~/.local/bin` directory ( the latter requires to be enabled into the `~/.bashrc` file, by adding the line `export PATH=$PATH:$(xdg-user-dir USER)/.local/bin` at the end of the file), this allows a single user to costumize its local configuration without having to share applications with others in the system.

For everything else, the controls and operation are always the same for both command line tools. The only thing that changes is that the installation scripts are written only for "AM", while "AppMan" uses the same scripts and includes commands that can modify them to make them work locally during the installation process.

More details about AppMan on the official repository, at https://github.com/ivan-hc/AppMan

-----------------------------------------------------------------------------
## What programs can be installed
AM installs/removes/updates/manages only standalone programs, ie those programs that can be run from a single directory in which they are contained (where `$PROGRAM` is the name of the application, AM installs them always into a dedicated folder named `/opt/$PROGRAM`).

These programs are taken:
- from official sources (see Firefox, Thunderbird, Blender, NodeJS, Chromium Latest...);
- from official .deb packages (see Brave, Vivaldi, Google Chrome...);
- from the repositories and official sites of individual developers (if an archive is not available, an official AppImage is used, see Libreoffice, OnlyOffice);
- from tar archives of other GNU/Linux distributions (see Chromium, Chromium Ungoogled...);
- from AUR or other Arch Linux-related sources (see Palemoon, Spotify, WhatsApp...);
- from AppImage recipes to be compiled with [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit) (see Anydesk, qBittorrent, Dropbox, all the games from the "KDE Games" suite...);
- from unofficial repositories of developers external to the project concerned (most of the time they are programs in AppImage format), but only if an official release is not available (see the various WINE, Zoom, VLC, GIMP...).

You can consult basic information, links to sites and sources used through the related `am -a $PROGRAM` command or by clicking [here](https://github.com/ivan-hc/AM-application-manager/tree/main/programs/.about).

-----------------------------------------------------------------------------
## How to update all programs, for real
To update all the programs, just run the command (without `sudo`):

	am -u
To update just one program (and to read the output from the shell):

    am -u $PROGRAM
Here are the ways in which the updates will be made:
- Updateable AppImages can rely on an [appimageupdatetool](https://github.com/AppImage/AppImageUpdate)-based "updater" or on their external zsync file (if provided by the developer);
- Non-updateable AppImages and other standalone programs will be replaced only with a more recent version if available, this will be taken by comparing the installed version with the one available on the source (using "curl", "grep" and "cat"), the same is for some AppImages created with [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit);
- Fixed versions will be listed with their build number (e.g. $PROGRAM-1.1.1). Note that most of the programs are updateable, so fixed versions will only be added upon request (or if it is really difficult to find a right wget/curl command to download the latest version).

During the first installation, the main user ($currentuser) will take the necessary permissions on each /opt/$PROGRAM directory, in this way all updates will be automatic and without root permissions.

-----------------------------------------------------------------------------
## Repository and Multiarchitecture
Each program is installed through a dedicated script, and all these scripts are listed in the "[repository](https://github.com/ivan-hc/AM-application-manager/tree/main/programs)" and divided by architecture.
NOTE that currently my work focuses on applications for x86_64 architecture, but it is possible to extend "AM" to all other available architectures.

Click on the link of your architecture to see the list of all the apps available on this repository:

- [x86_64](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/x86_64-apps)
- [i686](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/i686-apps)
- [aarch64](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/aarch64-apps)

If you are interested, you can deliberately join this project.

-----------------------------------------------------------------------------
# Comparison with other package managers
"AM" is not a project that wants to compete with the basic package managers of GNU/Linux distributions, being many managed programs come from different distributions (including Debian, Arch Linux and Slackware), but wants to favor the promotion of standalone programs and lighten the load of the developers of the distributions, separating the programs of the base system from those of the individual developers, in order to increase the general stability of the system and fill the shortcomings of one or of the other distribution:

### 1) "AM" versus APT/DNF/PacMan/any AUR helper
- Any traditional package manager follows precise patterns in integrating software and sharing libraries among the various applications in the system, and this last point can create conflicts that lead to the malfunction of one program compared to another. Furthermore, the programs differ in version according to the kind of software update model between the various distributions, the rolling-releases distributions (for example Arch Linux and Slackware) tend to always have the latest version while the fixed-release distributions (for example Debian Stable) often get older program versions.
- "AM" tends to get always the last version of each program from the main developer's source, and being them only standalone programs, they will be stored in just one dedicated folder, each script just need to download the standalone program into a dedicated `/opt/$PROGRAM` directory, creates the launcher in `/usr/share/application` and a link into a `$PATH` (ie `/usr/bin`, `/usr/local/bin` or `/usr/games`). In case no alternative sources are available, "AM" can compile and create AppImages using pkg2appimage and appimagetool, and these can be distributed on all other GNU/Linux distributions.

### 2) "AM" versus Flatpak
 - Flatpak is one of the most popular projects for redistributing standalone programs, but it takes too much space for each individual application, as several hundred megabytes of libraries are created since the first program is installed (just like creating a virtual machine to use programs on the host) and while on the one hand the application is free to function (almost) perfectly, on the other hand the consumption of physical memory is practically shameful;
 - "AM" doesn't uses any runtime, but only standalone programs that rarely require additional libraries (and in that case they are libraries already installed by default on any GNU/Linux system), ie bundle archives or (if necessary) AppImages (which being a compressed format, saves disk space), making the full installation really... flat (forgive me for the irony, but I could not resist).

### 3) "AM" versus Snap
- Snappy is a package manager devised by Canonical Ltd. and a software package format (SNAP) initially only for Ubuntu, but is also adopted by other distributions. It slows down PC resources due to the "snapd" daemon, so the more programs you install, the greater the system's boot time (and less is the free RAM);
- "AM" has no daemons and no hidden services are needed, each program is completely standalone and will run when you want to use it.

### 4) "AM" versus any other AppImage Manager
- There are many other AppImage managers around, and almost all of them support their database on appimagehub or other official AppImage resources, but the big problem is at the base of the compilation of these packages, being very often without an integrated update system. Furthermore, AppImage is a format that many developers are abandoning in favor of Flatpak, also because there were no centralized repositories or software that managed its updates in a universal way... at least until the invention of the first draft of [AppMan](https://github.com/ivan-hc/AppMan), and therefore of its successor, "AM";
- With "AM" each installed program has its own script (AM-updater) that compares the installed version with the one available in the sources or uses official tools to update the AppImages ([see above](#how-to-update-all-programs-for-real)), there is support for multiple architectures (including i686 and aarch64) and anyone can create a script to install that particular program (if available for its architecture).
 
#### NOTE: "AM" consider AppImage not to be a priority format, but only a fallback, because if a program is already made available in a bundle by the main developer, "AM" will prefer it. Some examples are given by Firefox, Thunderbird, NodeJS, Blender, Chromium Latest, SuperTuxKart... they are all programs provided in bundle, no other kind of package manager is really needed for them.

-----------------------------------------------------------------------------

# Installation
To install "AM" quickly, just copy/paste the following command:
	
    wget https://raw.githubusercontent.com/ivan-hc/APPLICATION-MANAGER/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL

Or use "GIT":

    git clone https://github.com/ivan-hc/AM-application-manager.git
    cd AM-application-manager
    chmod a+x INSTALL
    sudo ./INSTALL
    
In both cases, the "INSTALL" script will create a dedicated /opt/am directory containing the ["APP-MANAGER"](https://github.com/ivan-hc/AM-application-manager/blob/main/APP-MANAGER) script (ie "AM" itself), a symlink for it in /usr/local/bin named `am` and the /opt/am/remove script needed to [uninstall](#uninstall) "AM" itself, if needed. A temporary folder named /opt/am/.cache will be created too, in wich each installation script or list of available applications (for your architecture) is downloaded.

-----------------------------------------------------------------------------
# Usage
  `-a`, `about` Shows the basic information, links and source of each app:
  
    am -a $PROGRAM
-----------------------------------------------------------------------------
  `-b`, `backup` Save the current version of a program you are interested in, the snapshot will be stored in /home/$USER/.am-snapshots/$PROGRAM (see "-o"): 
  
    am -b $PROGRAM
-----------------------------------------------------------------------------
  `-c`, `clean` Removes all the unnecessary files:
  
    am -c
-----------------------------------------------------------------------------
  `-d`, `download` Download an installation script from the "AM" repository to your desktop without installing it:
  
    am -d $PROGRAM
-----------------------------------------------------------------------------  
  `-f`, `files` Shows the installed programs managed by "AM":
  
    am -f
-----------------------------------------------------------------------------
  `-h`, `help` Prints this message:
  
    am -h
-----------------------------------------------------------------------------
  `-i`, `install` Install a program. This will be downloader/created into a dedicated /opt/$PROGRAM directory (containing a script to remove it and  another one to update it), the command is linked to a $PATH and a launcher AM-$PROGRAM.desktop will be created in /usr/share/applications:
  
    [sudo] am -i $PROGRAM
-----------------------------------------------------------------------------
  `-l`, `list` Shows the list of apps available in the repository:
  
    am -l
-----------------------------------------------------------------------------
  `-o`, `overwrite` Overwrite the existing version of the program with a saved snapshot from /home/$USER/.am-snapshots/$PROGRAM (see "-b"):
  
    am -o $PROGRAM
-----------------------------------------------------------------------------
  `-q`, `query` Use one or more keywords to search for in the list of available applications:
  
    am -q $KEYWORD
-----------------------------------------------------------------------------
  `-r`, `remove` Removes the program and all the other files listed above using the instructions in /opt/$PROGRAM/remove. Confirmation is required (Y or N, default is Y):
  
    [sudo] am -r $PROGRAM
-----------------------------------------------------------------------------
  `-s`, `sync` Updates "AM" to a more recent version:
  
    am -s
-----------------------------------------------------------------------------
  `-t`, `template` This option allows you to generate a custom script from a list of different templates that may be vary according to the kind of $PROGRAM you want to create/install/update. Once you choose a number, the script will download the template by renaming it using the argument "$PROGRAM" you provided above:
  
    am -t $PROGRAM
-----------------------------------------------------------------------------
  `-u`, `update` Update all the installed programs:
  
    am -u
   To update just one program and read the shell's output:

    am -u $PROGRAM
-----------------------------------------------------------------------------
  `-v`, `--version`, `version` Shows the version of "AM":
  
    am -v
-----------------------------------------------------------------------------
  `-w`, `web` Shows the URLs of the sites/sources of $PROGRAM:
  
    am -w $PROGRAM
-----------------------------------------------------------------------------
  `--disable-completion` Removes the /etc/bash_completion.d/am-completion.sh script previously created with the "[sudo] am --enable-completion" command:
  
    [sudo] am --disable-completion  
-----------------------------------------------------------------------------
  `--enable-completion` Create a bash completion script in /etc/bash_completion.d to complete a keyword with the TAB key using the names of all installable applications in the "AM" repository:
  
    [sudo] am --enable-completion
-----------------------------------------------------------------------------
  `lock` Lock the selected $PROGRAM to the current installed version, this only works if a dedicated "AM-updater" script exists:
  
    am lock $PROGRAM
-----------------------------------------------------------------------------
  `unlock` Unlock updates for the selected $PROGRAM. This option nulls "lock", the update file is renamed as "AM-updater" again, so that it can be intercepted when executing the "am -u" command (see "-u"):
  
    am unlock $PROGRAM
-----------------------------------------------------------------------------

# Features
------------------------------------------------------------------------
### How to enable bash completion
Since 2.3.1 release "AM" has its inbuilt bash completion script that can be enabled using the following command (as root):

    sudo am --enable-completion
This will ceate a bash completion script in /etc/bash_completion.d named `am-completion.sh` needed to complete a keyword with the TAB key using the names of all the main options and the name of the scripts of all the applications available in the "AM" repository.
To disable bash completion (and to remove the /etc/bash_completion.d/am-completion.sh script):

    sudo am --disable-completion
Here you are a video on how to disable/enable bash completion in "AM":

https://user-images.githubusercontent.com/88724353/155971864-783c098c-e696-47b5-aaa8-85dab6ab3b46.mp4

A more detailed guide on how to create your own bash completion script for your project is available [here](https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial).

------------------------------------------------------------------------
### Snapshots: backup your app and restore to a previous version
Since 2.6.1 release, "AM" supports snapshots of all installed applications. A selected program can be copied locally into your home folder.

Here you are a video on how to backup/restore works in "AM":

https://user-images.githubusercontent.com/88724353/157094646-0e29ddbe-6cb7-4880-8414-110db071e617.mp4

- option `-b` or `backup` creates the snapshot, usage:

      am -b $PROGRAM
- option `-o` or `overwrite` allows you to roll back to a previous version of the program. Usage:

      am -o $PROGRAM
All the snapshots are stored into an hidden `/home/$USER/.am-snapshots` folder containing other subfolders, each one has the name of the programs you've done a backup before. Each snapshot is named with the date and time you have done the backup. To restore the application to a previous version, copy/paste the name of the snapshot when the `-o` option will prompt it.

------------------------------------------------------------------------
# Install/update/remove programs without "AM"
"AM" focuses a lot on the autonomy of its programs, so much that you can install, update and remove them without necessarily having "AM" installed on your system.
- To install a program without "am", replace "SAMPLE" at the line 2 with the name of the program you want to install:
	
	  ARCH=$(uname -m)
	  PROGRAM=SAMPLE
	  wget https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/$ARCH/$PROGRAM
	  chmod a+x ./$PROGRAM
	  sudo ./$PROGRAM
- To update a program without "am" instead, just run:
	
	  /opt/$PROGRAM/AM-updater
Note that this works only if the program has a /opt/$PROGRAM/AM-updater script, other programs like Firefox and Thunderbird are auto-updatable. 
	
- To uninstall a program without "am":
	
	  sudo /opt/$PROGRAM/remove

------------------------------------------------------------------------
# Create your own script
"AM" has a `-t` option (or `template`) with which you can get a script to customize according to your needs. With this option, you can quickly create scripts to download existing programs or even create AppImage or AppDir through tools such as appimagetool and pkg2appimage.

The following video shows how to create and test an AppImage of "Abiword" from Debian Unstable repository with a custom AppRun (option 5):

https://user-images.githubusercontent.com/88724353/150619523-a45455f6-a656-4753-93fe-aa99babc1083.mp4

The currently available templates are stored [here](https://github.com/ivan-hc/AM-application-manager/tree/main/templates), more will be added with the next versions of "AM".

A wiki is also available, here I will try to explain the installation script's workflow for a program to be better managed by "AM", trying to use a language that is as simple and elementary as possible.

Each script is written exclusively for "AM" (and is structured in such a way that even "[AppMan](https://github.com/ivan-hc/AppMan)", the non-root version of "AM", can modify it to manage programs locally).

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
	
The "AM" installation scripts, including those created by you with the -t option that we have just seen, all follow very specific guidelines.

Some "templates" are already available [here](https://github.com/ivan-hc/AM-Application-Manager/tree/main/templates) or by downloading them using the `-t` option, this way:

    am -t $PROGRAM

Where $PROGRAM is the name of the program you want to create a script for. The command will generate a script named $PROGRAM.AM (I wrote the availability of a ".AM" extension to prevent overwriting of files on your desktop with the same name of the script you want write, you can safelly remove it).

If you open the script, you can read some uppercased parts that you must replace manually (ICON, LAUNCHER, URL...).

------------------------------------------------------------------------
# Uninstall
To uninstall "AM" just run the command:

	sudo am -r am

------------------------------------------------------------------------	
# Known issues
"AM" itself works well, but there are a few things to consider before, after and during use:
- The "AM" scripts use the basic commands usually found in any GNU / Linux distribution (wget, curl, grep, egrep, find, rm, mkdir, mv, ls, echo...), make sure you have them before performing any operation;
- The task of "AM" is solely to install / remove / update the applications managed by it. Problems related to the failure of an installed program or any related bugs are attributable solely to its developers. You can view the link to each project's repository or official site via the "`am -a $PROGRAM`" command;
- The developer of AM has compiled the application installation scripts based on any links made publicly available by the owners of the affected software (or from official repositories of other progressive release distributions, for example Debian Unstable, Arch Linux, Slackware ...) . These urls (with particular reference to the official ones of the developers) may not work in the future if the developers decide to modify the site, the tags, the repository or any detail that the script refers to to install / update the application. In this case, [please report the problem to the "AM" team](https://github.com/ivan-hc/AM-application-manager/issues) who will modify or (in the worst case) remove the installation script until the problem is resolved;
- "AM" is an open source project, you can read and compile the scripts to your liking, as long as they don't damage your system. All scripts have been tested on Debian Testing / Unstable (64 bit) and Debian 11 (32 bit) and should work on any GNU / Linux distribution, regardless of the initialization process (with or without systemd).

------------------------------------------------------------------------
# Related projects
##### External sources and tools used in many scripts
- appimagetool from https://github.com/AppImage/AppImageKit
- libunionpreload from https://github.com/project-portable/libunionpreload
- pkg2appimage, at https://github.com/AppImage/pkg2appimage

##### My other projects
- appman from https://github.com/ivan-hc/AppMan
- arch-deployer from https://github.com/ivan-hc/Arch-Deployer
- firefox for linux scripts, at https://github.com/ivan-hc/Firefox-for-Linux-scripts

##### My forks
- pkg2appimage for 32 bit systems, at https://github.com/ivan-hc/pkg2appimage-32bit

------------------------------------------------------------------------
# Conclusions
Having encouraged you to visit this page is already a huge achievement for me, being this my second creation after AppMan. This project is much more demanding than AppMan, as each individual program requires a different script to check the version of the installed program and compare it to the source link, so each individual program can take hours of testing before being published in the repository, and between my real job and other family commitments, I try to carve up some free time for this project.

If you wish, you can support me, this work and my passion with a small [donation](https://paypal.me/ivanalexhc), I will gladly appreciate it. Thank you.
