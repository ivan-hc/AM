There are so many commands to remember among the GNU/Linux distributions, and sometime there is not what I really want from a package manager:

- I want an app totally independent from the repositories of my distribution;
- it must not require hundreds of packages and files of dependencies;
- my app must not share its dependencies with other installed applications;
- this app must always be updated to the latest version, even at the cost of updating without asking, I just want to use it;
- it must also be available for other users who use my pc;
- I want this app to be easy to install and remove using an extremely intuitive command;
- I want to summarize the whole installation process, including icons, launchers, info files and a script to remove all this in just one script.

So I've created another tool... again!

------------------------------------------------------------------------
                                                                           
                AAA               PPPPPPPPPPPPPPPPP   PPPPPPPPPPPPPPPPP   
               A:::A              P::::::::::::::::P  P::::::::::::::::P  
              A:::::A             P::::::PPPPPP:::::P P::::::PPPPPP:::::P 
             A:::::::A            PP:::::P     P:::::PPP:::::P     P:::::P
            A:::::::::A             P::::P     P:::::P  P::::P     P:::::P
           A:::::A:::::A            P::::P     P:::::P  P::::P     P:::::P
          A:::::A A:::::A           P::::PPPPPP:::::P   P::::PPPPPP:::::P 
         A:::::A   A:::::A          P:::::::::::::PP    P:::::::::::::PP  
        A:::::A     A:::::A         P::::PPPPPPPPP      P::::PPPPPPPPP    
       A:::::AAAAAAAAA:::::A        P::::P              P::::P            
      A:::::::::::::::::::::A       P::::P              P::::P            
     A:::::AAAAAAAAAAAAA:::::A      P::::P              P::::P            
    A:::::A             A:::::A   PP::::::PP          PP::::::PP          

------------------------------------------------------------------------

 >>  Enjoy your applications without thinking about anything else   <<   
  
------------------------------------------------------------------------

[Installation](#installation)

[Usage](#usage)

[Updates](#updates)

[Repository and... rules?](#repository-and-rules)

[Uninstall only "APP"](#uninstall-only-app)

[Uninstall "APP" and all the other programs](#uninstall-app-and-all-the-other-programs)

[Conclusions](#conclusions)

-----------------------

"APP" is inspired from my other project, [AppMan](https://github.com/ivan-hc/AppMan), an application manager for standalone programs and AppImages that works like APT or Pacman. In this case the commands are less, because there are less things to do. "APP" is built to allow integration in the system and automatic updates for each application, so the final user must do nothing but just using the application.

"APP" seems to be a too much generic name for a command line tool, but it represents just what it aims to manage, ie only standalone applications!

Each app managed by this tool can be just installed or removed using the related command, while updates must be automatic and related just to that program, not to the whole repository of the distribution. "APP" has not other options.

"APP" is easy to use the same way you write it.

-----------------------

# Installation
Copy/paste this command:

`wget https://raw.githubusercontent.com/ivan-hc/APP-Manager/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL`

This will download the ["app"](https://github.com/ivan-hc/APP-Manager/blob/main/app) script in /opt/app, a symlink for it in /usr/bin, a /opt/app/programs folder (where [each installation script of the programs you'll install](https://github.com/ivan-hc/APP-Manager/tree/main/programs) will be stored) and the /opt/app/remove script needed to uninstall "APP" (keep reading).

# Usage

  `app [option]`
  
  where option include:
  
  `-h`, `help`	Print this message.

  `-f`, `files`	Show the programs installed.

  `-s`, `sync`	Updates "APP" to a more recent version.

  -----------------------------------------------------------------------
      
  `app [option] [argument]`
  
  where option include:
  
  `-i`, `install` Install a program. This will be taken directly from the
  		repository of the developer (always the latest version):
  		- the installer is stored in /opt/app/programs;
  		- the command is linked to a $PATH;
		- the program is stored in /opt/<program> with a script to
	    	remove this and all the files listed above.
		The icon and the launcher are optional for no-ui programs.
  		APP uses both AppImages and other standalone programs.
  		
  `-r`, `remove` Removes the program and all the other files listed above
  		using the instructions in /opt/app/remove/<program>.
  		Confirmation is required (Y or N, default is N).

# Updates
Each script will create, among other things, another update-oriented script, which can be activated when the program itself starts or by adding a relative `<program>-update` between the processes that you want to start at login. To make this possible, each user must be given the necessary permissions on each program folder.

NOTE that the AppImages are using [appimageupdate](https://github.com/AppImage/AppImageUpdate), a command line tool available for both i386 and x86_64 architectures, install it using the command:
	
`sudo app install appimageupdate`
	
#### WARNING! Programs that update at startup can slow down your system, and programs that include update at startup may take a long time to open before the update is complete.

# Multiarchitecture
Currently my work focuses on applications for x86_64 architecture, but it is possible to extend "APP" to all other available architectures. If you are interested, you can deliberately join this project.
	
# Repository and... rules?
Each [$PROGRAM](https://github.com/ivan-hc/APP-Manager/tree/main/programs) only uses a dedicated script. Once you've performed the command:
	
`sudo app install $PROGRAM`
	
The script will create:
- a /opt/$PROGRAM folder containing the standalone app, an uninstaller script named `remove` and other files (maybe related to the automatic updates);
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
	
### And since the "app" command has not yet been invented by anyone, I gladly take advantage of it.
