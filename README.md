There are so many commands to remember among the GNU/Linux distributions, and sometime there is not what I really want from a package manager... so I've created another tool... again: EYA!

                                                                         
     >>  Enjoy Your Apps... without thinking about anything else   <<    


EYA means "Enjoy Your Apps" and it is inspired from my other project, [AppMan](https://github.com/ivan-hc/AppMan), an application manager for standalone programs and AppImages that works like APT or Pacman. In this case the commands are less, because there are less things to do. EYA is built to allow integration in the system and automatic updates for each application, so the final user must do nothing but just using the application.

### To install EYA:

`wget https://raw.githubusercontent.com/ivan-hc/EYA-App-Manager/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL`

### To remove it:

`sudo eya remove eya`

# Usage

  `eya [option]`
  
  where option include:
  
  `-h`, `help`	Print this message.

  `-f`, `files`	Show the programs installed.

  `-s`, `sync`	Updates EYA to a more recent version.

  -----------------------------------------------------------------------
      
  `eya [option] [argument]`
  
  where option include:
  
  `-a`, `about`	Show basic info on each application installed.
  		  
  `-i`, `install` 	Install a program. This will be taken directly from the
  		repository of the developer (always the latest version):
  		- the installer is stored in /opt/eya/programs;
  		- the program is stored in /opt/<program>;
  		- the icon is pushed in /usr/share/pixmaps;
  		- the launcher is created /usr/share/applications;
  		- the command is linked to /usr/bin;
  		- the uninstaller is created in /opt/eya/remove;
  		- other files can be stored in /opt/<program>.
  		The icon and launcher are not needed for no-ui programs.
  		EYA uses both AppImages and other standalone programs.
  		
  `-r`, `remove`	Removes the program and all the other files listed above
  		using the instructions in /opt/eya/remove/<program>.
  		Confirmation is required (Y or N, default is N).

# Updates
Each script will create, among other things, another update-oriented script, which can be activated when the program itself starts or by adding a relative `<program>-update` between the processes that you want to start at login. To make this possible, each user must be given the necessary permissions on each program folder.

NOTE that the AppImages are using `appimageupdate`, install it using the command `sudo eya install appimageupdate`
           
# Uploaded programs
Each $PROGRAM uses just one dedicated script that interacts with `sudo eya install $PROGRAM`. A complete list is [here](https://github.com/ivan-hc/EYA-App-Manager/tree/main/programs). If you want to add a program, just compile a script by yourself. I personally will try to import so many scripts from [AppMan](https://github.com/ivan-hc/AppMan) as possible (if I have time enough).
