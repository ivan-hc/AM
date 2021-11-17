This is a first attempt to create an application manager for standalone programs and AppImages that works like APT or Pacman similar to [AppMan](https://github.com/ivan-hc/AppMan) but with system integration and automatic updates for each application.

Actually this is a pure alpha, use it at your own risk!

### To install this program:

`wget https://raw.githubusercontent.com/ivan-hc/want/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL`

### To remove it:

`sudo want remove want`

# Usage

To install a program: `sudo want install <program>` or `sudo want -i <program>`

To allow updates on each program: `sudo chown -R $USER /opt/<program>`

To remove a program: `sudo want remove <program>` or `sudo want -r <program>`

To update "want": `sudo want sync` or `sudo want -s`

To know what programs are installed: `want files` or `want -f`
