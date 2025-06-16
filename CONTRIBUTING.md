# Contributing to "AM"
First off, thanks for taking the time to contribute!

-----------------------------------------------

## Found a Problem?
Before reporting a problem, be it a bug, design or others, we assume you have made sure that:
1. [the README.md](https://github.com/ivan-hc/AM/blob/main/README.md) does not cover your problem
2. the problem has not been reported in the [issue tracker](https://github.com/ivan-hc/AM/issues)
3. the problem is not related to the installed apps but to the [installation scripts](https://github.com/ivan-hc/AM/tree/main/programs)
4. the "AM"/"AppMan" command line interface [is updated to the latest version](https://github.com/ivan-hc/AM/releases/latest)

If all apply, then please consider opening a [new issue](https://github.com/ivan-hc/AM/issues).

-----------------------------------------------

## Want to submit a new app?
Use the option `-t` to create the installation script:
```
am -t my-appname
```
where `$XDG_DESKTOP_DIR` is your Desktop directory and `$ARCH` is your system architecture (for example x86_64 or i686), the "am-scripts" directory will contain the installation scripts in "$ARCH". Use the option `-i` to test the installation of the script:
```
am -i $XDG_DESKTOP_DIR/am-scripts/$ARCH/my-script
```
among the other stuff in the "am-scripts" directory created with the option `-t` you can see:
- the "list" file, containing the lines to add to the list of available applications (the file "$ARCH-apps" available [here](https://github.com/ivan-hc/AM/tree/main/programs), **NOT the one named "$ARCH"-appimages**, the latter is managed by the maintainer of this repository);
- the directory bearing the name of our catalog, "[portable-linux-apps.github.io](https://portable-linux-apps.github.io)", its enough to drag/drop the content of this directory for a pull request on the dedicated [repo](https://github.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io).

**NOTE: if you are not sure, submit your request at https://github.com/ivan-hc/AM/issues , we will try to provide all the above as soon as possible.**

-----------------------------------------------

## Want to Submit Code?
You can submit code by:
1. fork this repository
2. install "AM" and "AppMan" using the guide at https://github.com/ivan-hc/AM#how-to-install-am
3. submit a [pull request](https://github.com/ivan-hc/AM/pulls)

-----------------------------------------------

## Want to contribute to the Development Branch and test newer features?
Enter the developer mode using the command
```
am --devmode-enable
```
to go back to the main stable branch instead
```
am --devmode-disable
```
***NOTE, using the "dev" branch can cause serious risks to system stability. Use at your own risk.***

-----------------------------------------------

### Credits
- [@nazdridoy](https://github.com/nazdridoy)
- [@zen0bit](https://github.com/zen0bit)
