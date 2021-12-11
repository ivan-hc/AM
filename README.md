# "AM", THE APPLICATION MANAGER

------------------------------------------------------------------------

 >>  Enjoy your applications without thinking about anything else   <<   
  
 ------------------------------------------------------------------------

[Introducing "AM"](#introducing-am)

[Installation](#installation)

[Usage](#usage)

[Updates](#updates)

[The only flaw](#the-only-flaw)

[Repository and Multiarchitecture](#repository-and-multiarchitecture)

[Scripts and rules](#scripts-and-rules)

[How to uninstall "AM"](#how-to-uninstall-am)

[How to uninstall a program using "AM"](#how-to-uninstall-a-program-using-am)

[How to uninstall a program without "AM"](#how-to-uninstall-a-program-without-am)

[Conclusions](#conclusions)

-----------------------------------------------------------------------------

# Introducing "AM"

There are so many commands to remember among the GNU/Linux distributions, and sometime I can't find what I really want from a package manager.

Here's what it means for me to use a completely "standalone" application:

- I want an app totally independent from the repositories of my distribution;
- it must not require hundreds of packages and files of dependencies;
- my app must not share its dependencies with other installed applications;
- this app must always be updated to the latest version, even at the cost of updating without asking, I just want to use it;
- it must also be available for other users who use my pc;
- I want this app to be easy to install and remove using an extremely intuitive command;
- I want to summarize the whole installation process, including icons, launchers, info files and a script to remove all this in just one script.

APT (Debian) often includes too old programs that require too many dependencies, while the programs installed by AUR (Arch Linux) are not always reliable, especially in terms of dependencies, and PacMan by default does not include all the programs that APT manages. Flatpak takes up too much disk space, while Snap slows down PC resources. AppImage doesn't have a centralized repository capable of automatically managing updates and tools such as "appimaged" are not enough to integrate the program in the correct way into the system.

Finally I decided to write my own script, again.

I have already wrote [AppMan](https://github.com/ivan-hc/AppMan), an application manager for standalone programs and AppImages that works like APT or Pacman, so the main problem for me was to find a name for a new command that was short, easy to remember and that fully reflected its purpose.

In the end I chose the most self-centered, obvious, stupid, brief... and bravest name that an amateur developer could give to an "application manager": `am`!

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

The `am` command is very similar to [AppMan](https://github.com/ivan-hc/AppMan), but with [less inbuilt options](#usage), because here are less things to do:

- the `am` script is built to allow integration in the system and automatic updates for each application, so the final user must do nothing but just using the application installed;
- this tool can only install, remove and search the desired application, updates are at the complete discretion and management of the latter;
- using the `am` command to install/remove standalone apps is as easy and ridiculous as typing a command at random, out of desperation!

#### "AM", thanks to its installation scripts that in turn create other scripts to check for updates by simply starting the installed applications, which are themselves isolated from each other, transforms Debian into a rolling-release distro and Arch Linux into a more stable system .

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
  		- the command is linked into a $PATH or launched from a 
		custom script (created in a $PATH) which automates updates
		at program startup;
		- the program is stored in /opt/$PROGRAM with a script to
	    	remove this and all the files listed above.
		The icon and the launcher are optional for no-ui programs.
  		"AM" uses both AppImages and other standalone programs.
  		
  `-r`, `remove` Removes the program and all the other files listed above
  		using the instructions in /opt/$PROGRAM/remove.
  		Confirmation is required (Y or N, default is N).
		
  `-t`, `template` This option allows you to generate a custom script to
  		manipulate on your PC in your $HOME directory. Please,
  		consider submitting your app to the AM application manager,
  		at https://github.com/ivan-hc/AM-application-manager

# Updates
As we have already seen, the installation script will create an additional script which will take the place of the symbolic link in $PATH (/usr/local/bin or usr/bin) and which will check for updates at program startup before running it. Here are the ways in which the updates will be made:
- Updateable AppImages can rely on an [appimageupdatetool](https://github.com/AppImage/AppImageUpdate)-based "updater" or on their external zsync file (if provided by the developer);
- Non-updateable AppImages and other standalone programs will be replaced only with a more recent version if available, this will be taken by comparing the installed version with the one available on the source (using "curl", "grep" and "cat");
- Fixed versions will be listed with their build number (e.g. $PROGRAM-1.1.1). Note that most of the programs are updateable, so fixed versions will only be added upon request (or if it is really difficult to find a right wget/curl command to download the latest version);
- AppImages created with [pkg2appimage](https://github.com/AppImage/pkg2appimage) and [appimagetool](https://github.com/AppImage/AppImageKit) will be updated in the same way as the non-updatable AppImages (see above), but the two tools just mentioned must be present in the system (the specific instruction to install or reinstall them will be present in the installation script of the program that requires it).

During the first installation, the main user ($currentuser) will take the necessary permissions on each /opt/$PROGRAM directory, in this way all updates will be automatic and without root permissions.


# The only flaw
	
Due to the automatic check for updates, each program may take longer than normal to start.

# Repository and Multiarchitecture
Each program is installed through a dedicated script, and all these scripts are listed in the "[repository](https://github.com/ivan-hc/AM-application-manager/tree/main/programs)" and divided by architecture.
	
###### NOTE that currently my work focuses on applications for x86_64 architecture (being AppMan wrote for x86_64 only), but it is possible to extend "am" to all other available architectures.

Click on the link of your architecture to see the list of all the apps available on this repository:

- [x86_64](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/x86_64-apps)
- [i686](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/i686-apps)
- [aarch64](https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/programs/aarch64-apps)

If you are interested, you can deliberately join this project.

I personally will try to import so many scripts from [AppMan](https://github.com/ivan-hc/AppMan) as possible (if I'll have time enough).

# Scripts and rules	
Once you've performed the command:
	
`sudo am install $PROGRAM`
	
The script will create:
- a /opt/$PROGRAM folder containing the standalone app, an uninstaller script named `remove` and other files (if necessary);
- a symlink of /opt/$PROGRAM/$YOUR-APP-AND-HELPERS into a $PATH (ie /usr/local/bin, /usr/bin, /bin, /usr/local/games, /usr/games...) or a script instead that checks for updates each time you launche the program;
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
As you can see, you're free to do whatever you want with your script! The [rules](#scripts-and-rules) of the `am` command are few and the [options](#usage) to use even fewer.

I created this program because I was bored every time I had to look for the new version of a program... and after all, even the name of the command, "am", I decided out of boredom. "AM" gives autonomy to every single installed application, and I try to add as many open source projects as possible.
	
"AM" can be interpreted as either "I am" or "Application Manager", or both (I am the Application Manager) representing what I was looking for from an application manager, and since the `am` command has not yet been invented by anyone, I gladly take advantage of it.

This project is much more demanding than AppMan, as each individual program requires a different script to check the version of the installed program and compare it to the source link, so each individual program can take hours of testing before being published in the repository, and between my real job and other family commitments, I try to carve up some free time for this project.
	
If you wish, you can support me, this work and my passion with a small [donation](https://paypal.me/ivanalexhc), I will gladly appreciate it. Thank you.
