# Troubleshooting

- [An application does not work, is old and unsupported](#an-application-does-not-work-is-old-and-unsupported)
- [Failed to open squashfs image](#failed-to-open-squashfs-image)
- [Cannot download or update an application](#cannot-download-or-update-an-application)
- [Cannot mount and run AppImages](#cannot-mount-and-run-appimages)
- [Spyware, malware and dangerous software](#spyware-malware-and-dangerous-software)
- [Stop AppImage prompt to create its own launcher, desktop integration and doubled launchers](#stop-appimage-prompt-to-create-its-own-launcher-desktop-integration-and-doubled-launchers)
- [The script points to "releases" instead of downloading the latest stable](#the-script-points-to-releases-instead-of-downloading-the-latest-stable)
- [Ubuntu mess](#ubuntu-mess)
- [Wrong download link](#wrong-download-link)

------------------------------------------------------------------------
### An application does not work, is old and unsupported
Use the `-a` option and go to the developer's site to report the problem. The task of "AM" is solely to install / remove / update the applications managed by it. Problems related to the failure of an installed program or any related bugs are attributable solely to its developers.

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](../README.md#main-index) |
| - | - |

------------------------------------------------------------------------
### Cannot download or update an application
There can be many reasons:
- check your internet connection;
- if the app is hosted on github.com, you have probably exceeded the hourly limit of API calls;
- the referring link may have been changed, try the `--rollback` option or `downgrade`;
- the reference site has changed, report any changes at https://github.com/ivan-hc/AM/issues
------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](../README.md#main-index) |
| - | - |

------------------------------------------------------------------------
### Cannot mount and run AppImages
If by running it in the terminal you get an error message about "FUSE" or "libfuse"/"libfuse2" missing, take a look at the official documentation:

https://docs.appimage.org/user-guide/troubleshooting/fuse.html

If your distro does not provide `libfuse2`, you can install it using the command:
```
am -i libfuse2
```
or
```
appman -i libfuse2
```
NOTE, in AppMan you still need to use your password (`sudo` or `doas`) to install the library at system level, in /usr/local/lib

Alternatively you can use the "`nolibfuse`" option to "try" to convert old Type2 AppImages to a new generation one, so as not to depend on `libfuse2`. In most cases it works, but sometimes it can give errors, depending on how the package was manufactured.

However, I suggest contacting the upstream developers to convince them to upgrade their packages.

* **If you cannot run some AppImages on Ubuntu 23.10+ or its derivatives, then refer to [Restricted unprivileged user namespaces are coming to Ubuntu 23.10 | Ubuntu](https://ubuntu.com/blog/ubuntu-23-10-restricted-unprivileged-user-namespaces) for possible causes and remedies or jump to "[Ubuntu mess](#ubuntu-mess)".**
* **If you cannot run chrome/chromium/electron-based AppImages, then refer to [Troubleshooting/Electron-sandboxing](https://docs.appimage.org/user-guide/troubleshooting/electron-sandboxing.html) for possible causes and remedies.**

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](../README.md#main-index) |
| - | - |

------------------------------------------------------------------------
### Failed to open squashfs image
When installing a script for an AppImage, you may see an error like this
```
This doesn't look like a squashfs image.
Failed to open squashfs image
sed: can't read ./appname.desktop: No such file or directory
mv: cannot stat './appname.desktop': No such file or directory
```
Basically, the installation process encounters errors while trying to extract the .deskto launcher and icon from the AppImage, and most likely, the entire application execution via terminal may fail, especially if installed locally, via AppMan.

Here's what you need to check:
- the installation status via your distribution repositories of the "squashfs-tools" package;
- the installation status of FUSE (whether it is version 2, 3 or higher);
- whether AppImageLauncher is installed or present on the system, if so remove it.

In the case of AppImageLauncher, as I write (today September 20, 2024), the repository has not been updated for a couple of years and the runtime used in the AppImages has changed. AppImageLauncher uses mechanisms to identify the AppImages present in the system, asking you to integrate them if you launch one. It acts a bit like a system daemon in effect, and could cause problems while you tend to manage the AppImages with different tools, and therefore even the execution via terminal can be problematic.

Remove AppImageLauncher and its files, then reboot the system (see also [issues/955](https://github.com/ivan-hc/AM/issues/955) and [issues/107](https://github.com/ivan-hc/AM/issues/107)).

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](../README.md#main-index) |
| - | - |

------------------------------------------------------------------------
### Spyware, malware and dangerous software
Before installing any application, try to know where it comes from first. This program provides you with two basic options for this purpose:
- Option `-a` or `about` (medium safety), allows you to read a short description and know the links from the pages of the site [https://portable-linux-apps.github.io](https://portable-linux-apps.github.io) locally, however these links may be inaccurate due to continuous updates of the initial scripts (you can provide additional info yourself by modifying the pages of the site, [here](https://github.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io), it is also open source);
- Option `-d` or `download` (absolute safety), this allows you to get the installation script directly on your desktop, so you can read the mechanisms and how it performs the downloads from the sources (in most cases there is a header for each step that explains what the listed commands do).

“AM” and AppMan are just tools to easily install all listed programs, but what you choose to install is your complete responsibility. **Use at your own risk**!

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](../README.md#main-index) |
| - | - |

------------------------------------------------------------------------
### Stop AppImage prompt to create its own launcher, desktop integration and doubled launchers
Some developers insist on creating Appimages that create their own launcher on first launch (like WALC and OpenShot). If the official solution proposed [here](https://discourse.appimage.org/t/stop-appimage-from-asking-to-integrate/488) doesn't work, you have two options to escape this trouble: "`-H`" and "`--sandbox`".

**1. Option "-H" or "home": create a .home directory for the AppImage**

Use the option `-H`, then launch the app and accept the request. Dotfiles and launcher will be saved in the $APP.home near the AppImage:
```
am -H $APP
$APP
```
or
```
appman -H $APP
$APP
```
you can also use the AppImage's builtin option `--appimage-portable-home` from the terminal:
```
$APP --appimage-portable-home
```
This method works in the 99% of cases.

**2. Option "--sandbox": run the AppImage into a Aisap/bubblewrap sandbox**

Use the option `--sandbox`, then launch the app and accept the request. Dotfiles and launcher will be saved in the dedicated sandbox:
```
am ---sandbox $APP
$APP
```
or
```
appman --sandbox $APP
$APP
```
This is the best method, since you decide wheter to allow the use of user's directories or not.

For more details, see "[**Sandbox an AppImage**](guides-and-tutorials/#sandbox.md)".

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](../README.md#main-index) |
| - | - |

------------------------------------------------------------------------
### The script points to "releases" instead of downloading the latest stable
This is a choice I made as many developers have abandoned support for AppImage or GNU/Linux in general. My aim here is to introduce you to other developers' applications, then it's up to you to contact them, support them, help improve the software through forks and pull requests, opening issues and encouraging developers to keep the software in the format you prefer.

In case you are sure that the upstream developer will maintain the package for each stable release, you can fix this in several ways:
#### Method 1: Direct installation by combining `-i` and `--force-latest` options
```
am -i --force-latest $PROGRAM
```
#### Method 2: "Downgrade" the installed app to "latest"
Use the option `--force-latest` to patch the AM-updater and perform the "update"/"downgrade":
```
am --force-latest $PROGRAM
```
or do it manually:
```
sed -i 's#releases -O -#releases/latest -O -#g' /opt/$PROGRAM/AM-updater
am -u $PROGRAM
```

See also "[Install the "latest" stable release instead of the latest "unstable"](#install-the-latest-stable-release-instead-of-the-latest-unstable)".

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](../README.md#main-index) |
| - | - |

------------------------------------------------------------------------
### Ubuntu mess
As the author of [this article](https://ubuntu.com/blog/ubuntu-23-10-restricted-unprivileged-user-namespaces) states, "*Ubuntu Desktop firmly places security at the forefront, and adheres to the principles of security by default*". Bullsh*t!

User namespaces are a feature of the kernel. It's a feature which is supported by the Linux kernel. When a vulnerability is found, it's given a CVE and the code is fixed appropriately. If the kernel developers wanted to disable this feature by default, or restrict it, they could do so themselves.

Introducing namespace restrictions via AppArmor is an additional security layer, but not required, since we already have more flexible sandboxing systems in the Linux world, in particular "[Bubblewrap](https://github.com/containers/bubblewrap)", used mainly by Flatpak and othe projects, including this and my other one, "[Archimage](https://github.com/ivan-hc/ArchImage)".

**Canonical has only one interest in applying all these restrictions to Ubuntu: to enforce the use of Snap!**

It's not that the Snapcraft database is that secure, it's not uncommon for some malicious user to have introduced malicious code into distributed applications. The reason they disable namespaces is due to some older privilege escalation bugs, but the problem with that is that it doesn't matter on desktop usage, any malware can just wait for you to enter your sudo password when updating, not to mention that it can already do everything the regular user can do, including deleting everything owned by the user. 

But as expected, Ubuntu is a distribution that knows how to attract criticism and disapproval. I say this as a former user (I started with Ubuntu 9.04): Canonical doesn't give a damn about Ubuntu users!

There are two solutions to this problem, one simple and one a little more complex:
1. The simple solution is to stop using Ubuntu, completely! Change distribution!
2. The slightly more complex solution is to disable restrictions, via the command line. If you decide to adopt this one, see below.

#### How to disable Apparmor restrictions
If you chose number two and you feel happy with Ubuntu, follow these steps (as suggested [here](https://github.com/linuxmint/mint22-beta/issues/82)):
1. run the following command to disable AppArmor restrictions (the file name is relative)
```
echo 'kernel.apparmor_restrict_unprivileged_userns = 0' | sudo tee /etc/sysctl.d/20-apparmor-mint.conf
```
2. Reboot.

------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](../README.md#main-index) |
| - | - |

------------------------------------------------------------------------
### Wrong download link
The reasons may be two:
- the referring link may have been changed, try the `--rollback` option or `downgrade`;
- the reference site has changed, report any changes at https://github.com/ivan-hc/AM/issues
------------------------------------------------------------------------

| [Back to "Troubleshooting"](#troubleshooting) | [Back to "Main Index"](../README.md#main-index) |
| - | - |

------------------------------------------------------------------------
