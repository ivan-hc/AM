#!/bin/sh

URL="https://raw.githubusercontent.com/ivan-hc/APP-Manager/main"

cd /opt/app
case "$1" in
  ''|'-h'|'help') echo '
 ------------------------------------------------------------------------

     >>  Enjoy Your Apps... without thinking about anything else   <<     

 ------------------------------------------------------------------------

  Usage:		app [option]
  
  where option include:
  
  -h, help	Print this message.

  -f, files	Show the programs installed.

  -s, sync	Updates APP to a more recent version.

  -----------------------------------------------------------------------
      
  Usage:		app [option] [argument]
  
  where option include:
  
  -a, about	Show basic info on each application installed.
  		  
  -i, install 	Install a program. This will be taken directly from the
  		repository of the developer (always the latest version):
  		- the installer is stored in /opt/app/programs;
  		- the icon is pushed in /usr/share/pixmaps;
  		- the launcher is created /usr/share/applications;
  		- the command is linked to /usr/bin;
		- the program is stored in /opt/<program> with an "about"
		file and a script to remove this and all the files listed
		above.
		The icon and launcher are not needed for no-ui programs.
  		"APP" uses both AppImages and other standalone programs.
  		
  -r, remove	Removes the program and all the other files listed above
  		using the instructions in /opt/app/remove/<program>.
  		Confirmation is required (Y or N, default is N).		 

  -----------------------------------------------------------------------
   
  SITE: https://github.com/ivan-hc/APP-Manager
  
  ' ;;
  '-a'|'about')
	while [ -n "$1" ]
	do
	case $2 in
	*) for var in $2;
	do cat /opt/$2/about; echo ""; done
	esac
	shift
	done;;
  '-f'|'files') echo ""; echo $(echo "  Applications installed on the system:"; ls /opt/app/programs/ | wc -l); echo ""; ls /opt/app/programs; echo "" ;;
  '-i'|'install')
	while [ -n "$1" ]
	do
	case $2 in
	*) for var in $2;
	do cd /opt/app/programs; mkdir tmp; cd tmp; wget $URL/programs/$2; cd ..; mv ./tmp/$2 ./$2; rmdir ./tmp;
	chmod a+x /opt/app/programs/$2 && exec /opt/app/programs/$2; done
	esac
	shift
	done;;
  '-r'|'remove')
	while [ -n "$1" ]
	do
	case $2 in
	*) for var in $2;
	do read -p "Do you wish to REMOVE this program (y,N)?" yn
		case $yn in
		[Yy]* ) exec /opt/$2/remove-$2; echo ""; echo "Application removed!"; echo ""; break;;
		[Nn]*|* ) echo "Aborted"; exit;; esac done;;
	esac
	shift
	done;;
  '-s'|'sync') echo ""; echo " Updating APP Manager, please wait..."; sleep 1;
  	cd /opt/app; mkdir tmp; cd ./tmp; wget -q $URL/app && chmod a+x ./app; cd ..;
  	mv /opt/app/tmp/app /opt/app; rmdir /opt/app/tmp; echo "...done!";;
  *) exec /opt/app/app ;;
esac
