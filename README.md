This is a first attempt to create an application manager for standalone programs and AppImages that works like APT or Pacman similar to [AppMan](https://github.com/ivan-hc/AppMan) but with system integration and automatic updates for each application.

Actually this is a pure alpha, use it at your own risk!

This project is totally experimental, and I will complete it as I have time.

### To install this program:

`wget https://raw.githubusercontent.com/ivan-hc/want/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL`

### To remove it:

`sudo want remove want`

# Usage
I have chosen to call this program `want` because its use can be as simple and intuitive as carrying out a search on the internet, so each option corresponds to the completion of a trivial sentence:

- To install a program do `sudo want install <program>` or `sudo want -i <program>`
- To remove a program do `sudo want remove <program>` or `sudo want -r <program>`
- To update "want" do `sudo want sync` or `sudo want -s`
- To know what programs are installed do `want files` or `want -f`

# Updates
Each script will create, among other things, another update-oriented script, which can be activated when the program itself starts or by adding a relative `<program>-update` between the processes that you want to start at login. To make this possible, each user must be given the necessary permissions on each program folder.
To allow updates on each program do `sudo chown -R $USER /opt/<program>`

NOTE that the AppImages are using `appimageupdate`, for now you can quickly install and integrate it using [AppMan](https://github.com/ivan-hc/AppMan).
