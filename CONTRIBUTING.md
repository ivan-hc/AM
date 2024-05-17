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

## Want to make code refactor?
“AM” is provided as-is, and each line has been tested to work as it should, based on user feedback and needs, as well as the aesthetic and practical preferences of the developer who created it, who provided it to you, and who constantly maintains it to make it work at its best.

Unfortunately, many contributors in the past, by relying exclusively on the logic of software such as "Shellcheck", without first verifying that the code worked, have caused more harm than good, both to the software and to its main developer, who ended up having to rewrite everything from scratch, losing time, mental health and trust towards their collaborators who had committed the mess.

The priority of this project is only one: **"AM" must work and that's it!**

Not out of malice, but if you got here and you like "AM" and how it works, you liked the work that the main developer did for you.

If you intend to carry out a "sensible" refactoring that doesn't risk breaking everything as it has already happened, you are welcome. But at the slightest mistake, you will be rejected, no ifs or buts. You are warned. Further errors will no longer be tolerated in this project and will be seen as attempts at sabotage!

If you believe that something needs improvement, let us know, but it is better for the refactoring to be carried out by someone who already knows the commands he wrote. It is certainly the best way to prevent everything from breaking and avoid irreversible damage.

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

## Want to help in some way?
Share the link to this repository on YouTube, Twitter, Reddit, Facebook or any other platform useful for making our work known.

-----------------------------------------------

## Want to submit a new app?

- [Guide for skilled people](#guide-for-skilled-people)
- [Guide for beginners](#guide-for-beginners)

### Guide for skilled people
If you are sure you can create an installation script yourself:
1. see "Want to Submit Code?", above
2. use the option `-t` to create a new script, everything will be created into a directory "am-scripts", on your desktop, containing
  - the installation script under am-scripts/$arch (where "$arch is the name of your architecture, for example x86_64)
  - a file named am-scripts/list containing the line to add in the list of applications (must be reduced to **max 80 characters in total**)
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
Submit your request at https://github.com/ivan-hc/AM/issues , we'll provide as soon as possible

-----------------------------------------------

### Credits
- This document was written by [@ivan-hc](https://github.com/ivan-hc) (owner)
- The creation of this document is a suggestion from [@nazdridoy](https://github.com/nazdridoy)
- Also thanks to [@zen0bit](https://github.com/zen0bit) for supporting
