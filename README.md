There are so many commands to remember among the GNU/Linux distributions, and sometime there is not what I really want from a package manager... so I've created another tool... again!

"APP" is inspired from my other project, [AppMan](https://github.com/ivan-hc/AppMan), an application manager for standalone programs and AppImages that works like APT or Pacman. In this case the commands are less, because there are less things to do. APP is built to allow integration in the system and automatic updates for each application, so the final user must do nothing but just using the application.

"APP" is just what is aims to manage: only standalone apps! Not a program from a centralized repository or managed through a Package Manager, but just a standalone app. "APP" is easier to remember and an app is just what many people want to manage.

Each app installed using this tool must be just installed or removed using the related command, while updates must be automatic and related just to that program, not to the whole repository of the distribution. "APP" has not other options. APP is easy to use the same way you write it.

# Installation

`wget https://raw.githubusercontent.com/ivan-hc/APP-Manager/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL`

# Usage

  `app [option]`
  
  where option include:
  
  `-h`, `help`	Print this message.

  `-f`, `files`	Show the programs installed.

  `-s`, `sync`	Updates "APP" to a more recent version.

  -----------------------------------------------------------------------
      
  `app [option] [argument]`
  
  where option include:
  
  `-a`, `about`	Show basic info on each application installed.
  		  
  `-i`, `install` Install a program. This will be taken directly from the
  		repository of the developer (always the latest version):
  		- the installer is stored in /opt/app/programs;
  		- the icon is pushed in /usr/share/pixmaps;
  		- the launcher is created /usr/share/applications;
  		- the command is linked to /usr/bin;
		- the program is stored in /opt/<program> with an "about"
		file and a script to remove this and all the files listed
		above.
		The icon and launcher are not needed for no-ui programs.
  		APP uses both AppImages and other standalone programs.
  		
  `-r`, `remove` Removes the program and all the other files listed above
  		using the instructions in /opt/app/remove/<program>.
  		Confirmation is required (Y or N, default is N).

# Updates
Each script will create, among other things, another update-oriented script, which can be activated when the program itself starts or by adding a relative `<program>-update` between the processes that you want to start at login. To make this possible, each user must be given the necessary permissions on each program folder.

NOTE that the AppImages are using `appimageupdate`, install it using the command `sudo app install appimageupdate`
	
#### WARNING! Programs that update at startup can slow down your system, and programs that include update at startup may take a long time to open before the update is complete.

           
# Repository and... rules?
Each [$PROGRAM](https://github.com/ivan-hc/APP-Manager/tree/main/programs) only uses a dedicated script. Once you've performed the command:
	
`sudo app install $PROGRAM`
	
The script will create:
- a /opt/$PROGRAM folder containing the standalone app, a file of basic info named `about`, an uninstaller script named `remove` and maybe other files related to the automatic updates;
- a symlink of /opt/$PROGRAM/$YOUR-APP-AND-HELPERS to a $PATH (ie /usr/local/bin, /usr/bin, /bin, /usr/local/games, /usr/games...);
- the icon, that can be placed, for example, in /usr/share/pixmaps or /usr/share/icons (optional for command line tools);
- the launcher in /usr/share/applications (optional for command line tools).
	
The more important thing is the /opt/$PROGRAM/remove script file, it must contain the path of all the files created by your script. It can be easilly called by "APP" also if you have removed and then re-installed "APP" itself, using the command:
	
`sudo app remove $PROGRAM`
	
### As you can see, you're free to do whatever you want with your script! The rules of "APP" are few and the commands to use even fewer.

I personally will try to import so many scripts from [AppMan](https://github.com/ivan-hc/AppMan) as possible (if I'll have time enough).
	
# Uninstall only "APP"
To remove only "APP" use the command:

`sudo app remove app`

NOTE that the /opt/app/programs folder will be still there to list all the programs installed using this tool. To remove it use the command:

`sudo rm -R /opt/app`

# Uninstall "APP" and all the other programs
Before you remove "APP", you should remove each program one by one using the `app remove <program>` command, this way:

`sudo app remove <program1>`

`sudo app remove <program2>`

`...`

`sudo app remove app && rm -R /opt/app`

# Conclusions
I created this program because I was bored every time I had to look for the new version of a program... and after all, even the name of the command, "app", I decided out of boredom.
