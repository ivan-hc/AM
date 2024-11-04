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
Option two is very similar to option zero, the one for AppImages, with very few fundamental differences:
- there is no reference to "`mage$`", so you will have to specify as a key word the extension of the file or archive to download, even if on github.com and codeberg.org
- you can choose to add an icon and customize a .desktop file if it is a graphical application

That said, we can even create a script for AppImage, but customizing the launcher and the icon without having to rely on the "standard" operations for which the template used in the Zero option is designed. As in this video, I'll use OBS Studio AppImage (even if this is not the use for which this template is intended)

https://github.com/ivan-hc/AM/assets/88724353/ce46e2f2-c251-4520-b41f-c511d4ce6c7d

As mentioned in parenthesis, the template is designed for many other uses, such as interception and extraction of portable archives in ZIP, TAR and 7z format, but also scripts and static binary files.

In addition, if you have chosen to add a launcher, you can always press enter and:
- the icon will be downloaded from the catalog [portable-linux-apps.github.io](https://portable-linux-apps.github.io/)
- the .deskto file will be minimal, without even names

And speaking of the .desktop file, you can replace it with the official one, copying its content... but be careful to replace the entries `Exec=` and `Icon=` with the following
```
Exec=$APP
Icon=/opt/$APP/icons/$APP
```
for example, if you have
```
[Desktop Entry]
Name=Friday Night Funkin'
Exec=PsychEngine
Terminal=false
Type=Application
Icon=io.github.shadowmario.fnf-psychengine.png
Comment=Engine originally used on Mind Games mod.
Categories=Game;
```
you must change it as
```
[Desktop Entry]
Name=Friday Night Funkin'
Exec=$APP
Terminal=false
Type=Application
Icon=/opt/$APP/icons/$APP
Comment=Engine originally used on Mind Games mod.
Categories=Game;
```
and most importantly, pay attention to the name of the binary file. In the example above we have `Exec=PsychEngine`, this means that the binary is not `$APP`, so you have to change the `chmod` (to made the file executable) and `ln` (to symlink the file in $PATH) references by adding the exact name of the binary, so the two references of `chmod`
```
chmod a+x ./$APP
```
must be
```
chmod a+x ./PsychEngine
```
and the `ln` reference must change from
```
ln -s "/opt/$APP/$APP" "/usr/local/bin/$APP"
```
to
```
ln -s "/opt/$APP/PsychEngine" "/usr/local/bin/$APP"
```
or you will get errors.

Same if the referenced binary is into a subdirectory. Sometime it can be into a "`bin`" directory or another path of the extracted archive. Well, in that case, you neeed to change the above like this
```
chmod a+x ./bin/PsychEngine
```
and
```
ln -s "/opt/$APP/bin/PsychEngine" "/usr/local/bin/$APP"
```
in short, if you are lucky and the binary has exactly the same name as `$APP` you will not have to change anything. Instead, you will have to manually intervene on the script, as I just described.

Note that the download rules are the same as for AppImages in the "Zero" option. If you know the content of the extracted archive, you will have no problem modifying the script manually. However, it is up to you to find the download URL.

In the case of archives, the sites github.com and codeberg.org are pre-set. Other sites must be set manually. So have the basic knowledge of SHELL described at [If the AppImage is hosted on other sistes](#if-the-appimage-is-hosted-on-other-sistes).

If in doubt, download the pre-existing installation scripts and analyze their contents to get an idea of ​​how they work.

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
The structure of an installation script is designed for a system-wide installation (as root), since it is intended to be hosted in this database. But every path indicated within it is written so that "`appman -i`" or "`am -i --user`" can patch the essential parts, to hijack the installation at a local level and without root privileges.

This is a step-by-step focus on how an installation script runs, and we will take `brave` (official archive) and `brave-appimage` (the unofficial AppImage), you will see that they have a similar structure:
1. The header, it is ment to set the `APP` and `SITE` variable
```
#!/bin/sh

# AM INSTALL SCRIPT VERSION 3.5
set -u
APP=brave
SITE="brave/brave-browser"
```
2. Create the working directories (where the app will be downloaded and installed) and the "`remove`" script. Thel latter is needed to quickly remove the app in case of wrong installation or other problems
```
# CREATE DIRECTORIES AND ADD REMOVER
[ -n "$APP" ] && mkdir -p "/opt/$APP/tmp" "/opt/$APP/icons" && cd "/opt/$APP/tmp" || exit 1
printf "#!/bin/sh\nset -e\nrm -f /usr/local/bin/$APP\nrm -R -f /opt/$APP" > ../remove
printf '\n%s' "rm -f /usr/local/share/applications/$APP-AM.desktop" >> ../remove
chmod a+x ../remove || exit 1
```
3. Download and prepare the app, this part sets the `version` variable we talked at [Option Zero: "**AppImages**"](#option-zero-appimages).

The structure of the first two lines are similar for both AppImages and archives.
```
version=$(curl -Ls https://api.github.com/repos/brave/brave-browser/releases/latest | sed 's/[()",{} ]/\n/g' | grep -oi "https.*" | grep -vi "i386\|i686\|aarch64\|arm64\|armv7l" | grep -i "https.*linux-amd64.zip$" | head -1)
wget "$version" || exit 1
```
but while archives have this to detect and extract packages that can be present, trying to extract the content at several levels...
```
[ -e ./*7z ] && 7z x ./*7z && rm -f ./*7z
[ -e ./*tar.* ] && tar fx ./*tar.* && rm -f ./*tar.*
[ -e ./*zip ] && unzip -qq ./*zip 1>/dev/null && rm -f ./*zip
cd ..
if [ -d ./tmp/* 2>/dev/null ]; then mv ./tmp/*/* ./; else mv ./tmp/* ./"$APP" 2>/dev/null || mv ./tmp/* ./; fi
```
...AppImages have a space where you can add manually the same commands if the AppImage is into another kind of archive
```
# Keep this space in sync with other installation scripts
# Use tar fx ./*tar* here for example in this line in case a compressed file is downloaded.
cd ..
mv ./tmp/*mage ./"$APP"
# Keep this space in sync with other installation scripts
```
all the rest is quite the same (all depends if the binary have a different name, see the last part of [Option Two: "**Archives and other programs**"](#option-two-archives-and-other-programs))
```
rm -R -f ./tmp || exit 1
echo "$version" > ./version
chmod a+x ./"$APP" || exit 1
```
4. Symlink (note, if the binary is different from `$APP`, use the exact name, see the last part of [Option Two: "**Archives and other programs**"](#option-two-archives-and-other-programs))
```
# LINK TO PATH
ln -s "/opt/$APP/$APP" "/usr/local/bin/$APP"
```
5. Creation of the script to update the program, also know as "AM-updater". It is a mix of the points 1 and 3, with in addition a system to detect newer versions of the app.
6. Launcher and icon, whe hare have a difference between how it works for AppImages...
```
# LAUNCHER & ICON
./"$APP" --appimage-extract *.desktop 1>/dev/null && mv ./squashfs-root/*.desktop ./"$APP".desktop
./"$APP" --appimage-extract .DirIcon 1>/dev/null && mv ./squashfs-root/.DirIcon ./DirIcon
COUNT=0
while [ "$COUNT" -lt 10 ]; do # Tries to get the actual icon/desktop if it is a symlink to another symlink
	if [ -L ./"$APP".desktop ]; then
		LINKPATH="$(readlink ./"$APP".desktop | sed 's|^\./||' 2>/dev/null)"
		./"$APP" --appimage-extract "$LINKPATH" 1>/dev/null && mv ./squashfs-root/"$LINKPATH" ./"$APP".desktop
	fi
	if [ -L ./DirIcon ]; then
		LINKPATH="$(readlink ./DirIcon | sed 's|^\./||' 2>/dev/null)"
		./"$APP" --appimage-extract "$LINKPATH" 1>/dev/null && mv ./squashfs-root/"$LINKPATH" ./DirIcon
	fi
	[ ! -L ./"$APP".desktop ] && [ ! -L ./DirIcon ] && break
	COUNT=$((COUNT + 1))
done
sed -i "s#Exec=[^ ]*#Exec=$APP#g; s#Icon=.*#Icon=/opt/$APP/icons/$APP#g" ./"$APP".desktop
mv ./"$APP".desktop /usr/local/share/applications/"$APP"-AM.desktop && mv ./DirIcon ./icons/"$APP" 1>/dev/null
rm -R -f ./squashfs-root
```
...and how it works with portable programs. You can add URLs to download them or commands to extract them from the package. Brave Browser have the easier system...
```
# ICON AND LAUNCHER
DESKTOP="https://raw.githubusercontent.com/srevinsaju/Brave-AppImage/master/AppDir/brave-browser.desktop"
wget "$DESKTOP" -O ./"$APP".desktop 2>/dev/null || exit 1
mv ./product*logo*128*.png ./DirIcon
sed -i "s#Exec=[^ ]*#Exec=$APP#g; s#Icon=.*#Icon=/opt/$APP/icons/$APP#g" ./"$APP".desktop
mv ./"$APP".desktop /usr/local/share/applications/"$APP"-AM.desktop && mv ./DirIcon ./icons/"$APP" 1>/dev/null
```
...but other programs have something like this (here `funkin-psych`).
```
# ICON
mkdir -p icons
wget https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/refs/heads/main/art/iconOG.png -O ./icons/"$APP" 2> /dev/null

# LAUNCHER
echo "[Desktop Entry]
Name=Friday Night Funkin'
Exec=$APP
Icon=/opt/$APP/icons/$APP
Terminal=false
Type=Application
Comment=Engine originally used on Mind Games mod.
Categories=Game;" > /usr/local/share/applications/"$APP"-AM.desktop
```

NOTE, all installation scripts work like this, except the ones for portable CLI apps, the ones without a GUI. There you can completely remove point 6 (create launcher and icon).

**This is all you need to know to create an installation script.**

------------------------------------------------------------------------

| [Back to "Templates index"](#templates-index) |
| - |

------------------------------------------------------------------------
## How to test an installation script
To install and test your script, use the command
```
am -i /path/to/your-script
```
or rootless
```
am -i --user /path/to/your-script
appman -i /path/to/your-script
```
To debug the installation, add the option `--debug`, like this
```
am -i --debug /path/to/your-script
```
or rootless
```
am -i --user --debug /path/to/your-script
appman -i --debug /path/to/your-script
```
You can also simply drag and drop files into the terminal for your testing, see the video down below

https://github.com/user-attachments/assets/2b687305-fe73-4109-8871-131173755306

NOTE, since you are experimenting with scripts you created, I highly recommend using for a rootless installation for your tests.

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
