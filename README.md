# "AM" the Application Manager for GNU/Linux

------------------------------------------------------------------------

  >>  Enjoy your applications without thinking about anything else   <<   
  
 ------------------------------------------------------------------------
 
 https://user-images.githubusercontent.com/88724353/148004386-01c0e38e-505a-428b-8dd9-3ec2a50c5229.mp4

 ------------------------------------------------------------------------

AM is an application manager for all GNU / Linux distributions and which can be adapted to all available architectures, as its scripts are entirely based on the programs present in each basic installation (wget, curl, grep, egrep, find, rm, mkdir, mv, ls, echo...). The "am" command is very easy to use and can manage a better control of automatic updates for all the programs installed. Using it to install/remove standalone apps is as easy and ridiculous as typing a command at random, out of desperation!

The main goal of this tool is to provide the same updated applications to multiple GNU/Linux distributions without having to change the package manager or the distro itself. This means that whatever distro you use, you will not miss your favorite programs or the need for a more updated version.

"AM" also aims to be a merger for GNU / Linux distributions, using not just AppImage as the main package format, but also other standalone programs, so without having to risk breaking anything on your system: no daemons, no shared libraries. Just your program!

 ------------------------------------------------------------------------

[Introducing "AM"](#introducing-am)

[Comparison with other package managers](#comparison-with-other-package-managers):
- [APT versus "AM"](#-apt-versus-am)
- [AUR & PacMan vs "AM"](#-aur--pacman-versus-am)
- [Flatpak versus "AM"](#-flatpak-versus-am)
- [Snappy versus "AM"](#-snappy-versus-am)
- [Any other AppImage Manager versus "AM"](#-any-other-appimage-manager-versus-am)

[Installation](#installation)
- [Usage](#usage)
- [What programs can be installed](#what-programs-can-be-installed)
- [Updates](#updates)
- [Repository and Multiarchitecture](#repository-and-multiarchitecture)
- [Scripts and rules](#scripts-and-rules)

[Uninstall](#uninstall)
- [Install/update/remove programs without "AM"](#installupdateremove-programs-without-am)

[Important](#important)

[Disclaim](#disclaim)

[Conclusions](#conclusions)

-----------------------------------------------------------------------------

# Introducing "AM"
There are so many commands to remember among the GNU/Linux distributions, and sometime I can't find what I really want from a package manager:

- I want my programs to be totally independent from the repositories of my distribution and from each other;
- My programs must not require hundreds of packages and files of dependencies and shared libraries scattered throughout the system;
- I want always the latest updated version of the program, maybe directly from the main developer;
- I want to install/remove/update/manage my programs using a short and extremely intuitive command;
- I want to update my programs without root privileges;
- Each installed program must be placed in a single folder with all dependencies, at most it can have a launcher and a link outside its own folder;
- I want to summarize the whole installation process (including the download of the icons and the creation of launchers and updater/remover scripts...) in just one script.

I can't find all this into other package managers. "AM" is created to do all this!

I've named it "AM", which is the abbreviation of Application Manager, because I wanted something that was really short to write and extremely easy to remember. At the same time this name had to be a word that fully expressed its functions. Two letters with a few simple options to remember (see "[Usage](#usage)"), to install, remove, update, manage programs on any GNU/Linux distribution and for any supported architecture, indiscriminately.

Such a simple name, like its structure and its intentions. "AM" is everything you would expect from any application manager.

# Comparison with other package managers
"AM" is not a project that wants to compete with the basic package managers of GNU / Linux distributions (in fact many managed programs come from different distributions, including Debian, Arch Linux, Slackware and various derivatives, and then make them available for all), but wants to favor the promotion of standalone programs and lighten the load of the developers of the distributions, separating the programs of the base system from those of the individual developers, in order to increase the general stability of the system and fill the shortcomings of one or of the other distribution.

### ◆ APT versus "AM"
- APT (Advanced Packaging Tool) is the standard software package manager of the Debian GNU/Linux distribution and all its derivatives (Ubuntu, Linux Mint, SparkyLinux, MX Linux, Kali Linux...). It often includes too old programs, due to the enormous workload of developers who try to make the same libraries available among the thousands of programs available interact, in order to make the distribution always stable and functional, whether it is the Stable, Testing or Unstable branch. Each program from APT require too many dependencies scattered throughout the system, so if a library is compatible for the package "X" and not for the package "Y", the latter will take a few days or several months to be released with a fairly recent version.
- "AM" has always the last version of each program that will be stored in just one dedicated folder, each script just need to download the standalone program into a dedicated `/opt/$PROGRAM` directory, creates the launcher in `/usr/share/application` and a link into a `$PATH` (ie `/usr/bin`, `/usr/local/bin` or `/usr/games`). However, "AM" may necessarily have to create an unofficial version of a given program (as AppImage) from Debian's Unstable branch, in case no alternative sources are available, and these can be distributed on all other GNU/Linux distributions that do not support APT.

## ◆ AUR & PacMan versus "AM" 
- Arch Linux is one of the most bleeding edge distributions in the GNU/Linux landscape, its package manager is PacMan (a contraction of "Package Manager") which despite being feature-rich and redistributing its packages between four main repositories (" core "," extra "," community "and" multilib "), has fewer software packages than APT. However, what makes Arch Linux superior to other distributions is the Arch User Repository (AUR) which allows anyone to add third party software, outside the main repositories. While this may seem like an advantage, on the other hand there is the risk of introducing malware and potentially dangerous software into the distribution itself, leading to system instability or distribution breakdown in the worst case. As with APT, PacMan and AUR must redistribute their software in various directories of the filesystem.
- "AM" has fewer programs, but only manages standalone software (ie bundle archives or AppImage) which cannot interact with each other, nor do they share libraries with the underlying system. As for the installation process, I refer you to the comparison with APT (so as not to be repetitive). However, "AM" can also retrieve programs from the AUR, or may create AppImage from the main repositories (see [Arch Deployer](https://github.com/ivan-hc/Arch-Deployer)) to make them available on all other GNU/Linux distributions.

## ◆ Flatpak versus "AM"
 - Flatpak (click [here](https://flatpak.org/faq/#Why_the_name_Flatpak_) to know the reason for choosing this name), developed by GNOME, is one of the most popular projects for redistributing standalone programs, but it takes too much space for each individual application, as a runtime of several hundred megabytes is created for each one (for me, it's like dedicating a virtual machine to each program) and while on the one hand the application is free to function (almost) perfectly, on the other hand the consumption of physical memory is practically shameful.
 - "AM" doesn't uses any runtime, but only standalone programs, ie bundle archives or (if necessary) AppImages (which being a compressed format, saves disk space), making the full installation really... flat (forgive me for the irony, but I could not resist).

## ◆ Snappy versus "AM"
- Snappy is a package manager devised by Canonical Ltd. and a software package format (SNAP) initially only for Ubuntu, but is also adopted by other distributions. It slows down PC resources due to the "snapd" daemon, so the more programs you install, the greater the system's boot time (and less is the free RAM).
- "AM" has no daemons and no hidden services are needed, each program is completely autonomous and will run when you want to use it (in any case, it is possible to convert Snap packages to AppImage, I have already done some tests for this, as their structure is quite similar... and I'm already thinking about writing a tool that can do that, so stay tuned).

## ◆ Any other AppImage Manager versus "AM"
- AppImage is a good package format, the first in the history of portable apps for GNU / Linux (think that the first draft dates back to 2004) and are strongly requested by many users who prefer them to programs managed by Flatpak and Snappy ... yet their great limitation is that they do not have a real centralized repository. The idea of the creator of this packaging format is to lead users to a program developer's website as you would on Microsoft Windows, that is, by opening a browser and downloading it from there, and without having to use "special tools" (probably his was a clear reference to the command line). However, there are many independent developer projects that support their application database on sites that the creator of the AppImage considers "official" (even if they are very neglected). I myself have created a tool that could install, update and manage them, [AppMan](https://github.com/ivan-hc/AppMan), but it also has severe limitations, including checking for available updates (many non-updateable AppImage must be re-downloaded, regardless of whether the new version is actually available or not) and somewhat messy integration into multi-account systems. The same code is written in a universal language among GNU/Linux distributions, however AppMan was written only for the x86_64 architecture. These are all details that led me to reformulate a new project.
- "AM" fixes all the errors of AppMan, being the direct successor and the perfect replacement for it. The operation is the same, but what changes is the approach with the system on which it is installed: it is possible to use the same program on several different accounts, each installed program has its own script that compares the installed version with the one available in the sources (see [updates](#updates)), there is support for multiple architectures (including i686 and aarch64) and anyone can create a script to install that particular program (if available for its architecture). But yet, "AM" consider AppImage not to be a priority format, but only a fallback, because if a program is already made available in a bundle by the main developer, "AM" will prefer it. Some examples are given by Firefox, Thunderbird, NodeJS, Blender, Chromium Latest, SuperTuxKart... they are all programs provided in bundle, no other kind of package manager is really needed for them (including "AM" itself, that is only an helper to spead them to the masses). If you want learn more about the programs that can be installed by AM, click [here](#what-programs-can-be-installed-with-am).

# Installation
Copy/paste this command:
	
    wget https://raw.githubusercontent.com/ivan-hc/APPLICATION-MANAGER/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL

This will download the ["APP-MANAGER"](https://github.com/ivan-hc/AM-application-manager/blob/main/APP-MANAGER) script in /opt/am, a symlink for it in /usr/local/bin named `am` and the /opt/am/remove script needed to uninstall `am` itself, if needed.

# Usage

  `am [option]`
  
  where option include:
  
  `-h`, `help`	Prints this message.

  `-f`, `files`	Shows the installed programs managed by "AM".
  
  `-l`, `list`	Shows the list of apps available in the repository.

  `-s`, `sync`	Updates "AM" to a more recent version.
  
  `-u`, `update` Update all the installed programs.

  -----------------------------------------------------------------------

  `am [option] [keywords]`
  
  where option include:  

  `-q`, `query`	Use one or more keywords to search for in the list of available applications.

  -----------------------------------------------------------------------
      
  `am [option] [argument]`
  
  where option include:
  
  `-a`, `about`	Shows the basic information, links and source of each app. 
  
  `-i`, `install` Install a program. This will be taken directly from the repository of the developer (always the latest version):
  		- the installer is stored in /opt/am/.cache;
  		- the command is linked into a $PATH;
		- the program is stored in /opt/<program> with all the related files (a script to remove this and all the files	listed above and a script to update everything).
		The icon and the launcher are optional for no-ui programs. "AM" uses both AppImages and other standalone programs. PASSWORD REQUIRED!
  		
  `-r`, `remove` Removes the program and all the other files listed above using the instructions in /opt/$PROGRAM/remove.
  		Confirmation is required (Y or N, default is N). PASSWORD REQUIRED!
		
  `-t`, `template` This option allows you to generate a custom script: the command will offer you to choose between different models that may be vary according to the type of application you want to create/install. Once you choose a number, the script will download the template and rename it using the <argument> you provided, all this will be created in the "Desktop" folder of the user. So you just have to edit the other parameters (LAUNCHER, AM-updater, Recipes, etc ...).
  		Please, consider submitting your custom script to "AM", at https://github.com/ivan-hc/AM-application-manager/pulls.

# What programs can be installed
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
	
# Updates
To update all the programs, just run the command (without `sudo`):

	am -u
Here are the ways in which the updates will be made:
- Updateable AppImages can rely on an [appimageupdatetool](https://github.com/AppImage/AppImageUpdate)-based "updater" or on their external zsync file (if provided by the developer);
- Non-updateable AppImages and other standalone programs will be replaced only with a more recent version if available, this will be taken by comparing the installed version with the one available on the source (using "curl", "grep" and "cat"), the same is for some AppImages created with [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit);
- Fixed versions will be listed with their build number (e.g. $PROGRAM-1.1.1). Note that most of the programs are updateable, so fixed versions will only be added upon request (or if it is really difficult to find a right wget/curl command to download the latest version).

During the first installation, the main user ($currentuser) will take the necessary permissions on each /opt/$PROGRAM directory, in this way all updates will be automatic and without root permissions.
			
# Repository and Multiarchitecture
Each program is installed through a dedicated script, and all these scripts are listed in the "[repository](https://github.com/ivan-hc/AM-application-manager/tree/main/programs)" and divided by architecture.
	
###### NOTE that currently my work focuses on applications for x86_64 architecture (being AppMan wrote for x86_64 only), but it is possible to extend "am" to all other available architectures.

Click on the link of your architecture to see the list of all the apps available on this repository:

- [x86_64](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/x86_64-apps)
- [i686](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/i686-apps)
- [aarch64](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/aarch64-apps)

If you are interested, you can deliberately join this project.

# Scripts and rules	
Once you've performed the command:
	
	sudo am -i $PROGRAM
	
The script will create:
- a /opt/$PROGRAM folder containing the standalone app, an uninstaller script named `remove`, an `AM-updater` script needed by the `am -u` command and other files (if necessary);
- a symlink of /opt/$PROGRAM/$YOUR-PROGRAM into a $PATH (ie /usr/local/bin, /usr/bin, /bin, /usr/local/games, /usr/games...);
- the icon (optional for command line tools), it can be placed in /usr/share/pixmaps, /usr/share/icons or in /opt/$PROGRAM (recommended);
- the launcher (optional for command line tools) in /usr/share/applications.
	
##### *NOTE that the /opt/$PROGRAM/remove script file is the more important part, it must contain the path of all the files created by your script, this way:
	
	rm -R -f /opt/$PROGRAM /usr/local/bin/$PROGRAM /usr/share/applications/$PROGRAM.desktop	
	
This scheme guarantees the removal of the program and all its components even without having to use "AM". Learn more [here](#how-to-uninstall-a-program-using-am). 

# Uninstall
	
	sudo am -r am

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

# Important
#### The programs installed with "AM" are official software in binary format or packaged as AppImage, their launchers are mostly the original ones, because of this they may conflict with / overwrite those of the same programs installed from the repository of your Linux distribution!
For example, if you install LibreOffice (any version) from "AM", the binary /opt/libreoffice/libreoffice is linked to /usr/local/bin as "libreoffice"	and it has its own launchers in /usr/share/applications (libreoffice.desktop, libreoffice-base.desktop, libreoffice-writer.desktop... etcetera).
If you already have an existing installation of LibreOffice from your package manager (APT / DNF / PacMan, Zypper ...), that won't work. There could also be more launchers in the application menu (if they have different names from the aforementioned, for example org.libreoffice.desktop, org.libreogffice.base.desktop ...) or they could be overwritten and recall the latest version installed (in our case the one coming from "AM").
	
#### So do not install programs from "AM" and your package manager together! Use ONLY the version you trust the most!
#### Install LibreOffice only from your package manager or only from "AM". Never together!

### The same applies to all other installed programs.
	
However, it is possible to solve the problem by customizing the scripts, perhaps assigning them a specific version of the software that will never be updated. "AM" tries to manage only the latest version of each program, but fixed versions also can be added to the repository, [if required](https://github.com/ivan-hc/AM-application-manager/pulls), you just have to ask.
	
# Disclaim
"AM" itself works well, but there are a few things to consider before, after and during use:
- The "AM" scripts use the basic commands usually found in any GNU / Linux distribution (wget, curl, grep, egrep, find, rm, mkdir, mv, ls, echo...), make sure you have them before performing any operation;
- The task of "AM" is solely to install / remove / update the applications managed by it. Problems related to the failure of an installed program or any related bugs are attributable solely to its developers. You can view the link to each project's repository or official site via the "`am -a $PROGRAM`" command;
- The developer of AM has compiled the application installation scripts based on any links made publicly available by the owners of the affected software (or from official repositories of other progressive release distributions, for example Debian Unstable, Arch Linux, Slackware ...) . These urls (with particular reference to the official ones of the developers) may not work in the future if the developers decide to modify the site, the tags, the repository or any detail that the script refers to to install / update the application. In this case, [please report the problem to the "AM" team](https://github.com/ivan-hc/AM-application-manager/issues) who will modify or (in the worst case) remove the installation script until the problem is resolved;
- "AM" is an open source project, you can read and compile the scripts to your liking, as long as they don't damage your system. All scripts have been tested on Debian Testing / Unstable (64 bit) and Debian 11 (32 bit) and should work on any GNU / Linux distribution, regardless of the initialization process (with or without systemd).


# Conclusions
Having encouraged you to visit this page is already a huge achievement for me, being this my second creation after AppMan. This project is much more demanding than AppMan, as each individual program requires a different script to check the version of the installed program and compare it to the source link, so each individual program can take hours of testing before being published in the repository, and between my real job and other family commitments, I try to carve up some free time for this project.
	
If you wish, you can support me, this work and my passion with a small [donation](https://paypal.me/ivanalexhc), I will gladly appreciate it. Thank you.
