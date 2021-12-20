# "AM", THE APPLICATION MANAGER

------------------------------------------------------------------------

 >>  Enjoy your applications without thinking about anything else   <<   
  
 ------------------------------------------------------------------------

[Introducing "AM"](#introducing-am)

[Installation](#installation)

[Usage](#usage)

[Updates](#updates)

[Repository and Multiarchitecture](#repository-and-multiarchitecture)

[Scripts and rules](#scripts-and-rules)

[How to uninstall "AM"](#how-to-uninstall-am)

[How to uninstall a program using "AM"](#how-to-uninstall-a-program-using-am)

[How to uninstall a program without "AM"](#how-to-uninstall-a-program-without-am)

[Conclusions](#conclusions)

-----------------------------------------------------------------------------

# Introducing "AM"

There are so many commands to remember among the GNU/Linux distributions, and sometime I can't find what I really want from a package manager:

- I want my programs to be totally independent from the repositories of my distribution and from each other;
- My programs must not require hundreds of packages and files of dependencies and shared libraries;
- I want always the latest updated version of the program, maybe directly from the developer;
- I want to install/remove/update/manage my programs using a short and extremely intuitive command;
- Each installed program must be placed in a single folder with all dependencies, at most it can have a launcher and a link outside its own folder;
- I want to summarize the whole installation process (including the download of the icons and the creation of launchers and updater/remover scripts...) in just one script.

I can't find all this into other package managers. APT (Debian) often includes too old programs that require too many dependencies, while the programs installed by AUR (Arch Linux) are not always reliable (and PacMan by default does not include all the programs that APT manages). Flatpak takes up too much disk space to install only one program, while Snappy slows down PC resources (not to mention I don't trust Canonical).

AppImage are a good package format, but they have not a centralized repository capable of automatically managing updates, and more often there are some external tools and system daemons that can't do enough to integrate the program in the correct way into the system (including launchers). I myself was not satisfied with my other creation, [AppMan](https://github.com/ivan-hc/AppMan), because it can manage them only locally (as a normal user without administrative privileges), and this conflicts with the possibility of making the installed applications also be used by other users who use my PC or laptop, and in this sense it is necessary an application manager that integrates with the system as APT, PacMan, DNF, Zypper could do (but with fewer files scattered around the PC). Also I'd like to be able to run many of the same applications on multiple different architectures (including 32-bit ones, now abandoned by many developers), while AppMan is only meant for x86_64, despite being written in a virtually universal language.

Initially I was undecided whether to develop something totally different, given the little free time I had available.

Finally I decided to write another tool based on AppMan itself.

### I've named it "`AM`", which is the abbreviation of Application Manager.

--------------------------------------------------------------
                    _____                    _____                                                                           
                   /\    \                  /\    \         
                  /::\    \                /::\____\        
                 /::::\    \              /::::|   |        
                /::::::\    \            /:::::|   |        
               /:::/\:::\    \          /::::::|   |        
              /:::/__\:::\    \        /:::/|::|   |        
             /::::\   \:::\    \      /:::/ |::|   |        
            /::::::\   \:::\    \    /:::/  |::|___|______  
           /:::/\:::\   \:::\    \  /:::/   |::::::::\    \ 
          /:::/  \:::\   \:::\____\/:::/    |:::::::::\____\
          \::/    \:::\  /:::/    /\::/    / ~~~~~/:::/    /
           \/____/ \:::\/:::/    /  \/____/      /:::/    / 
                    \::::::/    /               /:::/    /  
                     \::::/    /               /:::/    /   
                     /:::/    /               /:::/    /    
                    /:::/    /               /:::/    /     
                   /:::/    /               /:::/    /      
                  /:::/    /               /:::/    /       
                  \::/    /                \::/    /        
                   \/____/                  \/____/         

-----------------------

AM is an application manager for all GNU / Linux distributions and which can be adapted to all available architectures, as its scripts are entirely based on the programs present in each basic installation. 

Strongly inspired by AppMan, `am` is very easy to use and can manage a better control of automatic updates for all the programs installed. Using `am` to install/remove standalone apps is as easy and ridiculous as typing a command at random, out of desperation!

The main goal of this tool is to provide the same updated applications to multiple GNU/Linux distributions without having to change the package manager or the distro itself. This means that whatever distro you use, you will not miss your favorite programs or the need for a more updated version.

"AM" also aims to be a merger for GNU / Linux distributions, using not just AppImage as the main package format, but also other standalone programs, so without having to risk breaking anything on your system: no daemons, no shared libraries. Just your program!

-----------------------

# Installation
Copy/paste this command:

`wget https://raw.githubusercontent.com/ivan-hc/APPLICATION-MANAGER/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL`

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

  `-q`, `query`	Use one or more keywords to search for in the list of
  		available applications.

  -----------------------------------------------------------------------
      
  `am [option] [argument]`
  
  where option include:
  
  `-a`, `about`	Shows the basic information, links and source of each app. 
  
  `-i`, `install` Install a program. This will be taken directly from the
  		repository of the developer (always the latest version):
  		- the installer is stored in /opt/am/.cache;
  		- the command is linked into a $PATH;
		- the program is stored in /opt/<program> with all the 
		related files (a script to remove this and all the files 
		listed above and a script to update everything).
		The icon and the launcher are optional for no-ui programs.
  		"AM" uses both AppImages and other standalone programs.
  		
  `-r`, `remove` Removes the program and all the other files listed above
  		using the instructions in /opt/$PROGRAM/remove.
  		Confirmation is required (Y or N, default is N).
		
  `-t`, `template` This option allows you to generate a custom script: the 
  		command will offer you to choose between different models 
  		that may be vary according to the type of application you 
  		want to create/install. Once you choose a number, the 
  		script will download the template and rename it using the 
  		<argument> you provided, all this will be created in the 
  		"Desktop" folder of the user. So you just have to edit the 
  		other parameters (LAUNCHER, AM-updater, Recipes, etc ...).
  		Please, consider submitting your custom script to "AM", at 
 		https://github.com/ivan-hc/AM-application-manager/pulls.


# Updates
Here are the ways in which the updates will be made:
- Updateable AppImages can rely on an [appimageupdatetool](https://github.com/AppImage/AppImageUpdate)-based "updater" or on their external zsync file (if provided by the developer);
- Non-updateable AppImages and other standalone programs will be replaced only with a more recent version if available, this will be taken by comparing the installed version with the one available on the source (using "curl", "grep" and "cat");
- Fixed versions will be listed with their build number (e.g. $PROGRAM-1.1.1). Note that most of the programs are updateable, so fixed versions will only be added upon request (or if it is really difficult to find a right wget/curl command to download the latest version);
- AppImages created with [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit) will be updated in the same way as the non-updatable AppImages (see above), but the two tools just mentioned must be present in the system (the specific instruction to install or reinstall them will be present in the installation script of the program that requires it).

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
	
`sudo am -i $PROGRAM`
	
The script will create:
- a /opt/$PROGRAM folder containing the standalone app, an uninstaller script named `remove`, an `AM-updater` script needed by the `am -u` command and other files (if necessary);
- a symlink of /opt/$PROGRAM/$YOUR-PROGRAM into a $PATH (ie /usr/local/bin, /usr/bin, /bin, /usr/local/games, /usr/games...);
- the icon (optional for command line tools), it can be placed in /usr/share/pixmaps, /usr/share/icons or in /opt/$PROGRAM (recommended);
- the launcher (optional for command line tools) in /usr/share/applications.
	
##### *NOTE that the /opt/$PROGRAM/remove script file is the more important part, it must contain the path of all the files created by your script, this way:

`rm -R -f /opt/$PROGRAM /usr/local/bin/$PROGRAM /usr/share/applications/$PROGRAM.desktop`	
	
This scheme guarantees the removal of the program and all its components even without having to use "AM". Learn more [here](#how-to-uninstall-a-program-using-am). 

# How to uninstall "am"

`sudo am remove am`

# How to uninstall a program using "am"
`sudo am remove <$PROGRAM>`

# How to uninstall a program without "am"
`sudo /opt/$PROGRAM/remove`

# Conclusions
Having encouraged you to visit this page is already a huge achievement for me, being this my second creation after AppMan. This project is much more demanding than AppMan, as each individual program requires a different script to check the version of the installed program and compare it to the source link, so each individual program can take hours of testing before being published in the repository, and between my real job and other family commitments, I try to carve up some free time for this project.
	
If you wish, you can support me, this work and my passion with a small [donation](https://paypal.me/ivanalexhc), I will gladly appreciate it. Thank you.
