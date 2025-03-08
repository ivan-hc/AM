This directory will contain scripts for building AppImage packages on the fly, where required.

Each script must have the name of the corresponding installation script, but with the ".sh" extension. For example:
```
/appimage-bulder-scripts/x86_64/calibre.sh
```
is used by
```
/programs/x86_64/calibre
```
It is assumed that all of the work for these scripts will be done during the installation process, in the "tmp" directory, so the scripts posted here will need to be able to compile and drop the AppImage into the same "tmp" directory. The rest of the installation process will handle the created AppImage as if it had been normally downloaded from the internet ready-made.

If you are a user of my tools, consider using [AppImaGen](https://github.com/ivan-hc/AppImaGen). 

Try not to use [Archimage](https://github.com/ivan-hc/ArchImage), as build times are longer and more resource intensive.

If your AppImage creation script requires specific dependencies, please let me know with a PR.

TIP, creating AppImage on the fly can take time and resources, depending on the complexity of the program being compiled. It is highly suggested to publish the AppImages to a repository, using Github Actions, [as I do](https://github.com/ivan-hc#my-appimage-packages).

### Syntax
try to use key commands at the beginning of the line, to allow the "install.am" module to determine whether a command not installed on the system is required by the Appimage assembly script. Fore example:
```
tar fx ...
ar x ...
```
to detect if "`tar`" and "`ar`" (from `binutils`) are needed.
