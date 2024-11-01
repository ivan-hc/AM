### Install AppImages not listed in this database but available in other github repos
From version 7.2 its possible to install AppImages not listed in this database, thanks to the option `-e` or `extra`.

You need to add the URL to the github repo before the name you want to give to the AppImage (for command line usage, for example).

Optionally, you can add a "keyword" if more AppImages are listed in the same repo.

Usage:
```
am -e $USER/$PROJECT $PROGRAM
am -e $USER/$PROJECT $PROGRAM $KEYWORD
```
or
```
appman -e $USER/$PROJECT $PROGRAM
appman -e $USER/$PROJECT $PROGRAM $KEYWORD
```
You can give whatever name you want to the apps (as long as they does not overlap with commands already existing on your system, be careful).

In this video I'll install AnyDesk as "remote-desktop-client":

https://github.com/user-attachments/assets/aa546905-38da-48b5-bb10-658426e8372b

In this other example, I'll install an obsolete version of WINE AppImage, from a repo that lists more versions of the same app:
1. the first attempt is without a keyword, so that the script picks the first AppImage in the list (for Debian Buster)
2. in the second attempt I'll use the keyword "arch" to pick the Arch-based AppImage

https://github.com/user-attachments/assets/af00a5f2-f3fe-4616-899a-155cb31d2acd

As you can see, there are all the files needed by any app listed in this database, also if an installation script for them does not exists.

Apps installed this way will enjoy the same benefits as those that can already be installed from the database with the "`-i`" or "`install`".

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |