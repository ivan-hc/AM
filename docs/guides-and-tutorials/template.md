# TEMPLATES: Create and test your own installation scripts
This is a step-by-step guide on how to create, understand and test installation scripts in this database. You can use the table of contents below to navigate between the sections easily.

**Are you ready? Let's get started!**

------------------------------------------------------------------------
## Templates index
------------------------------------------------------------------------
[Create your installation script](#create-your-installation-script)
- [Option Zero: "**AppImages**"](#option-zero-appimages)
  - [If the AppImage is hosted on github or codeberg](#if-the-appimage-is-hosted-on-github-or-codeberg)
  - [If the AppImage is hosted sourceforge](#if-the-appimage-is-hosted-sourceforge)
  - [If the AppImage is hosted on other sistes](#if-the-appimage-is-hosted-on-other-sistes)
- [Option One: "**build AppImages on-the-fly**"](#option-one-build-appimages-on-the-fly)
- [Option Two: "**Archives and other programs**"](#option-two-archives-and-other-programs)
- [Option Three: "**Firefox profiles**"](#option-three-firefox-profiles)

[How an installation script works](#how-an-installation-script-works)

[How to test an installation script](#how-to-test-an-installation-script)

[How to submit a Pull Request](#how-to-submit-a-pull-request)

------------------------------------------------------------------------
## Create your installation script
Option `-t` or `template` allows you to create an "AM" compatible installation script using a "[templates](https://github.com/ivan-hc/AM/tree/main/templates)" that can be used by both "AM" and "AppMan". In fact, all AppMan does is take the installation scripts from this database and patch them to make them compatible with a rootless installation.

The syntax to follow is this
```
am -t $PROGRAM
```
or
```
appman -t $PROGRAM
```
and this is the screen that will appear:

![Istantanea_2024-06-17_21-35-26 png](https://github.com/ivan-hc/AM/assets/88724353/6e11aeff-9a70-44f7-bd73-1324b545704e)

Each option corresponds to a different type of application or helper to target with an installation script:

0. For **AppImages**, [press "0" (zero)](#option-zero-appimages)
1. To **create an AppImage on the fly** using [appimagetool](https://github.com/AppImage/AppImageKit) and [pkg2appimage](https://github.com/AppImage/pkg2appimage), [press "1" (one)](#option-one-build-appimages-on-the-fly)
2. For a **portable program** (archive, binary, script...), [press "2" (two)](#option-two-archives-and-other-programs)
3. For a **custom Firefox profile**, [press "3" (three)](#option-three-firefox-profiles)

**The next four paragraphs will explain in detail how to use the options [0](#option-zero-appimages), [1](#option-one-build-appimages-on-the-fly), [2](#option-two-archives-and-other-programs) and [3](#option-three-firefox-profiles).**

------------------------------------------------------------------------

| [Back to "Templates index"](#templates-index) |
| - |

------------------------------------------------------------------------
## Option Zero: "AppImages"
The easiest script to create is certainly the one relating to AppImages, the "Zero" option.

Much depends on the site it is hosted on.

### If the AppImage is hosted on github or codeberg
If the AppImage is hosted on github.com or codeberg.org, a default command will be added that is common with other repositories.

You can also specify whether to always download from "latest" (not recommended) or from the most recent release (the default).

Here's how to quickly create a script for an AppImage available on a github repository.

https://github.com/user-attachments/assets/1eec87ae-79b8-4637-a8b4-1c6314f88b86

Typically, this approach takes into account excluding all non-x86_64 architectures using the `grep -vi` command and including URLs starting with http and ending with "mage", i.e. `grep -i "http.*mage$"`.

It will also show a preview of the download URL that will be used.

If a repository contains multiple items, specify a keyword to include (choose 1) or exclude (choose 2).

In the following video, we will create a script for SimpleScreenRecorder, which is present in a repository where there are multiple AppImage packages. In the first attempt it will show me "Webcamoid", but adding the keyword `simplescreenrecorder` will give us the exact URL, as the keyword is "unique" for that package.

https://github.com/user-attachments/assets/e7bfed10-375f-405f-af7b-da7cd74862b8

This ease is due to the choice of the reference site: if you choose a URL that contains the word `github.com` or `codeberg.org`, the detection will be automatic. It is therefore preferable to add only the github/codeberg repository instead of main sites if you want an easy life.

Using different sites in fact starts to make things more complicated. See below.

### If the AppImage is hosted sourceforge
If the AppImage is hosted on sourceforge.net, a dedicated function will try to intercept the app by browsing the APIs. You can also use services like repology.org if you want to find the version of the application, if it is not present in the download URL.

About the source, it should be enough to add something like this
```
https://sourceforge.net/p/$projectname
```
where $projectname is ne name of the referenced page on sourceforge.net.

You need also to specify a description for it.

A preview of the download URL will be shown as well.

Here is how to create an installation script for "Nootka".

https://github.com/user-attachments/assets/c1c08c93-3a57-45b9-9515-551555eca3c4

NOTE, if the URL does not always appear. In that case, you need to resort to more "drastic" methods. See below.

### If the AppImage is hosted on other sistes
For AppImages published elsewhere, you will need more advanced knowledge of how to find the latest download URL using `curl` and `wget` (preferably the former), as well as knowledge of how to use `sed`, `grep`, and `tr`. Again, you may choose to use repology.org to determine the version if it is not present in the download URL.

When downloading an installation script using the command `am -d $program` you will notice in most cases a variable "`$version`", which represents the URL for downloading the application.

In the previous cases, it is easy to preset a URL for download, being generically "standard" sites.

Here is how a version variable looks for Abiword (github)...
```
version=$(curl -Ls  https://api.github.com/repos/ivan-hc/Abiword-appimage/releases | sed 's/[()",{} ]/\n/g' | grep -oi "https.*mage$" | grep -vi "i386\|i686\|aarch64\|arm64\|armv7l" | head -1)
```
...for SimpleScreenRecorder (still github)...
```
version=$(curl -Ls  https://api.github.com/repos/ivan-hc/Database-of-pkg2appimaged-packages/releases | sed 's/[()",{} ]/\n/g' | grep -oi "https.*mage$" | grep -vi "i386\|i686\|aarch64\|arm64\|armv7l" | grep -i "simplescreenrecorder" | head -1)
```
...and for Nootka (sourceforge)
```
version=$(curl -Ls https://sourceforge.net/p/nootka/activity/feed | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep -i "appimage" | grep -v '%' | head -1)
```
...namely, the three AppImages created previously.

All three have in common the following command, which downloads the package.
```
wget "$version" || exit 1
```
While **this is how a "`version`" variable looks in many sites other than the standard ones**, Inkscape for example have no `wget "$version"` reference...
```
version=$(wget -q https://repology.org/project/inkscape/related -O - | grep "version-newest" | head -1 | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}")
wget "$(echo "https://inkscape.org/$(curl -Ls $(echo "https://inkscape.org/release/inkscape-$(curl -Ls https://inkscape.org/ | grep -Po '(?<=class="info")[^"]*' | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}" | head -1)/gnulinux/appimage/dl/") | grep "click here" | grep -o -P '(?<=href=").*(?=">click)')")" || exit 1
```
...this is "Lens" instead...
```
version=$(echo "https://api.k8slens.dev/binaries/Lens-$(wget -q https://repology.org/project/lens-kubernetes/versions -O - | grep "newest version" | head -1 | grep -o -P '(?<=">).*(?=</a)' | sed 's/^.*>//')-latest.x86_64.AppImage")
wget "$version" || exit 1
```
...and this is "Ember"
```
version=$(wget -q https://repology.org/project/ember/versions -O - | grep -i "new.*version" | head -1 | tr '><' '\n' | grep "^[0-9]")
wget "$(curl -Ls https://www.worldforge.org/downloads/ | tr '"' '\n' | grep -i "^http.*appimage")" || exit 1
```
interventions like this are mostly manual.

It is advisable to test the commands to intercept the URL in another shell first, and then add them during the script creation process.

NOTE, if finding a download URL seems so difficult, consider instead that the rest of the script remains almost the same as all the other scripts. You will not have to tamper with anything else... except for rare exceptions (for example, if the AppImage is enclosed in a zip/tar/7z archive...).

In any case, read the content of the template, it is divided into sections that explain step by step what it does.

The templates are by @Samueru-sama

------------------------------------------------------------------------

| [Back to "Templates index"](#templates-index) |
| - |

------------------------------------------------------------------------
## Option One: "build AppImages on-the-fly"
This was one of the very first approaches used to create this project. Before I started building AppImage packages myself, they were first compiled just like using any AUR-helper.

From version 7.1, the installation script for the AppImages is used, with the only difference that it points only to the version, while a second script will be downloaded, published separately, at [github.com/ivan-hc/AM/tree/main/appimage-bulder-scripts](https://github.com/ivan-hc/AM/tree/main/appimage-bulder-scripts), which will have the task of assembling the AppImage in the directory on the fly "tmp", during the installation process. When the second script has created the .AppImage file, the first script will continue the installation treating the created AppImage as a ready-made one downloaded from the internet.

In this video we see how "calibre" is installed (note that a "calibre.sh" file is downloaded during the process):

https://github.com/ivan-hc/AM/assets/88724353/e439bd09-5ec6-4794-8b00-59735039caea

In this video, I run the aforementioned "calibre.sh" script in a separate directory, in a completely standalone way:

https://github.com/ivan-hc/AM/assets/88724353/45844573-cecf-4107-b1d4-7e8fe3984eb1

Two different operations (assembly and installation) require two different scripts.

Fun fact, up until version 7, this option included a unique template that installed and assembled the AppImage on the fly (see [this video](https://github.com/ivan-hc/AM/assets/88724353/6ae38787-e0e5-4b63-b020-c89c1e975ddd)). This method has been replaced as it was too pretentious for a process, assembly, which may instead require many more steps, too many to be included in both an installation script and an update script (AM-updater).

------------------------------------------------------------------------

| [Back to "Templates index"](#templates-index) |
| - |

------------------------------------------------------------------------
## Option Two: "Archives and other programs"
Option two is very similar to option zero. What changes is the number of questions, which allow you to customize both the application's .desktop file and the way a program should be extracted.

This script also supports extraction of *7z, *tar* and *zip files, if those archives are downloaded instead of a standalone binary.

By default, the install script does not have a launcher and icon. To create one, press "Y", otherwise, press "N" or leave it blank. This is useful if you want to load scripts or tools that can be used from the command line.

This option may be used also for AppImages, if you need to customize the launcher.

Tu add an icon, you need an URL to that, but if you don't have one, just leave blank. The script will download an icon from [portable-linux-apps.github.io](https://portable-linux-apps.github.io/) if it is hosted there, when running the installation script.

In this example, I'll use OBS Studio AppImage.

https://github.com/ivan-hc/AM/assets/88724353/ce46e2f2-c251-4520-b41f-c511d4ce6c7d

------------------------------------------------------------------------

| [Back to "Templates index"](#templates-index) |
| - |

------------------------------------------------------------------------
## Option Three: "Firefox profiles"
Option 3 creates a launcher that opens Firefox in a custom profile and on a specific page, such as in a WebApp. I created this option to counterbalance the amount of Electron/Chrome-based applications (and because I'm a firm Firefox's supporter).

It is enough to give an AppName, a URL to the icon (a correct one, not like the one suggested in the video, down below) and a category.

Here is an example for "ProtonMail"

https://github.com/user-attachments/assets/120012de-777f-4cd0-8324-f761d8d4947a

In practice, all we need to do is create a custom Firefox profile that can be launched from a .desktop file, which is all we are really creating in this process.

**These "objects" are not even classified as applications**, and **therefore are not included in the application count when you run `am -l`**.

As suggested in the video, it is preferable to have these custom profiles for yourself.

Their advantage is to keep the data of the reference site well separated from the system profile used in Firefox.

------------------------------------------------------------------------

| [Back to "Templates index"](#templates-index) |
| - |

------------------------------------------------------------------------
## How an installation script works
The structure of an installation script is designed for a system-wide installation, with "AM", since it is intended to be hosted in the database. But every path indicated within it is written so that "AppMan" can patch the essential parts, to hijack the installation at a local level and without root privileges:
1. In the first step, the variables are indicated, such as the name of the application and a reference to the source of the app (mostly used in `--rollback` or `downgrade`);
2. Create the directory of the application;
3. The first file to be created is "`remove`", to quickly remove app's pieces in case of errors;
4. Create the "tmp" directory, in which the app will be downloaded and, in the case of archives, extracted;
5. Most scripts contain a "$version" variable, a command to intercept the URL to download the app. If the URL is linear and without univoque versions, "$version" can be used to detect a version number. Then save the value into a file "version" (this is important for the updates, see point 7);
6. Downloading the application (and extract it in case of archive);
7. Create the "AM-updater" file, the script used to update the app. It resumes points 4, 5 and 6, with the difference that the "$version" variable we have saved at point 5 is compared with a new value, hosted at the app's source;
8. Creation/extract/download launcher and icon, the methods change depending on the type of application. For AppImages they are extracted from the package.

------------------------------------------------------------------------

| [Back to "Templates index"](#templates-index) |
| - |

------------------------------------------------------------------------
## How to test an installation script
To install and test your script, use the command
```
am -i /path/to/your-script
```
or
```
appman -i /path/to/your-script
```
To debug the installation, add the option `--debug`, like this
```
am -i --debug /path/to/your-script
```
or
```
appman -i --debug /path/to/your-script
```

------------------------------------------------------------------------

| [Back to "Templates index"](#templates-index) |
| - |

------------------------------------------------------------------------
## How to submit a Pull Request
A good example of how Pull Requests should be done is given by the user @Sush-ruta https://github.com/ivan-hc/AM/pull/981 https://github.com/ivan-hc/AM/pull/1000 https://github.com/ivan-hc/AM/pull/960 https://github.com/ivan-hc/AM/pull/957

All files and directories are created and saved in your XDG_DESKTOP directory (~/Desktop), under "`am-scripts`". This is the structure of the directories, considering that the scripts we create ar for the x86_64 architecture...
```
~/Desktop/am-scripts
	|
	|-portable-linux-apps.github.io
	|	|
	|	|-apps
	|	|
	|	|-icons
	|
	|-x86_64
	|   |
	|   |-$appname
	|
	|-list
```
...where `portable-linux-apps.github.io` and `x86_64` are main directories, `apps` and `icons` are subdirectories, `$appname` is the script and `list` is the list of the applications you have created:
1. fork this repository
2. upload the `$appname` script from the `x86_64` directory to the "`programs/x86_64`" directory of the repository
3. drag and drop all the .md Markdown files from `portable-linux-apps.github.io/apps` to the first comment
4. still in the first comment, copy/paste the contents of the "`list`" file

I'll take care of the rest.

------------------------------------------------------------------------

| [Back to "Templates index"](#templates-index) |
| - |

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
