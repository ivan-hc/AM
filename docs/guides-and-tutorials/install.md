## Install applications
The option `-i` or `install` is the one responsible of the installation of apps or libraries.

### Install, normal behaviour
This is the normal syntax:
```
am -i $PROGRAM
```
or
```
appman -i $PROGRAM
```
in this video I'll install AnyDesk:

https://github.com/user-attachments/assets/62bc7444-8b1f-4db2-b23b-db7219eec15d

### Install, debug an installation script
The "install.am" module contains some patches to disable long messages. You can see them with the suboption `--debug`:
```
am -i --debug $PROGRAM
```
or
```
appman -i --debug $PROGRAM
```
let test again the installation of AnyDesk using the `--debug` flag:

https://github.com/user-attachments/assets/9dd73186-37e2-4742-887e-4f98192bd764

### Install the "latest" stable release instead of the latest "unstable"
By default, many installation scripts for apps hosted on github will point to the more recent generic release instead of "latest", which is normally used to indicate that the build is "stable". This is because upstream developers do not always guarantee a certain packaging format in "latest", sometimes they may only publish packages for Windows or macOS, so pointing to "latest" would not guarantee that any package for Linux will be installed.

On the other hand, if you know that the upstream developer will always guarantee a Linux package in "latest" and "AM" instead points to a potentially unstable development version (Alpha, Beta, RC...), this is the syntax to adopt:
```
am -i --force-latest $PROGRAM
```
or
```
appman -i --force-latest $PROGRAM
```
in this video I'll install "SqliteBrowser" using the `--force-latest` flag:

https://github.com/user-attachments/assets/ee29adfd-90e1-46f7-aed9-b9c410f68776

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |