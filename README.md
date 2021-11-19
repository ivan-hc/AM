There are so many commands to remember among the GNU/Linux distributions, and sometime there is not what I really want from a package manager... so I've created another tool... again!

"APP" is inspired from my other project, [AppMan](https://github.com/ivan-hc/AppMan), an application manager for standalone programs and AppImages that works like APT or Pacman. In this case the commands are less, because there are less things to do. APP is built to allow integration in the system and automatic updates for each application, so the final user must do nothing but just using the application.

"APP" is just what is aims to manage: only standalone apps! Not a program from a centralized repository or managed through a Package Manager, but just a standalone app. "APP" is easier to remember and an app is just what many people want to manage.

Each app installed using this tool must be just installed or removed using the related command, while updates must be automatic and related just to that program, not to the whole repository of the distribution. "APP" has not other options. APP is easy to use the same way you write it.

### To install "APP" Application Manager:

`wget https://raw.githubusercontent.com/ivan-hc/APP-Manager/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL`

### To remove it:

`sudo app remove app`

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
           
# The "repository"
Each $PROGRAM only uses a dedicated script which interacts with `sudo app install $PROGRAM`. A full list is [here](https://github.com/ivan-hc/APP-Manager/tree/main/programs).
	
If you want to add a program just compile a script by yourself which also contains the creation of a script named `remove-$PROGRAM` in a dedicated path named `/opt/$PROGRAM` which allows the complete uninstallation of all the files installed with your script (that will be downloaded in `/opt/app/programs`).

I personally will try to import so many scripts from [AppMan](https://github.com/ivan-hc/AppMan) as possible (if I have time enough).

# Conclusions
I created this program because I was bored every time I had to look for the new version of a program... and after all, even the name of the command, "app", I decided out of boredom.
