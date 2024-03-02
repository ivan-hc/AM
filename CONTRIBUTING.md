# Contributing to "AM"
First off, thanks for taking the time to contribute!

-----------------------------------------------

## Found a Problem?
Before reporting a problem, be it a bug, design or others, we assume you have made sure that:
1. [the README.md](https://github.com/ivan-hc/AM/blob/main/README.md) does not cover your problem
2. the problem has not been reported in the [issue tracker](https://github.com/ivan-hc/AM/issues)
3. the problem is not related to the installed apps but to the [installation scripts](https://github.com/ivan-hc/AM/tree/main/programs)

If all apply, then please consider opening a [new issue](https://github.com/ivan-hc/AM/issues).

-----------------------------------------------

## Want to Submit Code?
You can submit code by:
1. forking the dev branch of this repository, at https://github.com/ivan-hc/AM/tree/dev
2. install "AM" using this guide https://github.com/ivan-hc/AM?tab=readme-ov-file#installation
3. also install "AppMan" using this other guide https://github.com/ivan-hc/AppMan?tab=readme-ov-file#installation
4. use YOUR FORK/BRANCH using the option "`newrepo`", for example, where your github profile is $USER and your branch is "dev", do:
```
am newrepo https://raw.githubusercontent.com/$USER/AM/dev
appman newrepo https://raw.githubusercontent.com/$USER/AM/dev
```
5. apply your changes on your fork and test them on both "AM" and AppMan until you're sure that they work without any problem
6. submit a [pull request](https://github.com/ivan-hc/AM/pulls) to the "dev" branch, at https://github.com/ivan-hc/AM/tree/dev

-----------------------------------------------

## Want to help in some way?
Share the link to this repository on YouTube, Twitter, Reddit, Facebook or any other platform useful for making our work known.

-----------------------------------------------

## Want to submit a new app?
### Guide for skilled people
If you are sure you can create an installation script yourself:
1. see "Want to Submit Code?", above
2. use the option `-t` to create a new script, everything will be created into a directory "am-scripts", on your desktop, containing
  - the installation script under am-scripts/$arch (where "$arch is the name of your architecture, for example x86_64)
  - a file named am-scripts/list containing the line to add in the list of applications (must be reduced to max 80 characters in total)
  - a Markdown file .md with the name of your app, under am-scripts/portable-linux-apps.github.io
3. install the script in "AM" and AppMan to test if it works for both
```
am -i $HOME/Desktop/am-scripts/$arch/your-app
appman -i $HOME/Desktop/am-scripts/$arch/your-app
```
4. upload the files
  - the script at https://github.com/ivan-hc/AM under /programs/$arch/
  - the line must be inserted in the list at https://github.com/ivan-hc/AM, the file is named /programs/$arch-apps
  - the Markdown file must be uploaded as is at https://github.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io, under the directory /apps
5. this step is optional, add a .png icon with the name lowercased of your app, sizes 128x128, at https://github.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io, undet the directory /icons
6. let us know about this with a pull request in this order
  - first pull request at https://github.com/ivan-hc/AM (the app must be on the database first)
  - second pull request at https://github.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io (the app from the database now can be in the catalogue)
This is important to launch the script that will update the count of the apps and their list also on the catalogue.

### Guide for beginners
Submit your request at https://github.com/ivan-hc/AM/issues/116 , we'll provide as soon as possible

-----------------------------------------------

### Credits
- This document was written by [@ivan-hc](https://github.com/ivan-hc) (owner)
- The creation of this document is a suggestion from [@nazdridoy](https://github.com/nazdridoy)
- Also thanks to [@zen0bit](https://github.com/zen0bit) for supporting
