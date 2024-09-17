## Install applications
The option `-i` or `install` is the one responsible of the installation of apps or libraries.

https://github.com/user-attachments/assets/62bc7444-8b1f-4db2-b23b-db7219eec15d

----------------------------------------------------
### Install, normal behaviour
This is the normal syntax.
```
am -i {PROGRAM}
```
To install programs locally, add the `--user` flag.
```
am -i --user {PROGRAM}
```
The latter corresponds to the syntax used in AppMan.
```
appman -i {PROGRAM}
```
Since version 9, "AM" also covers locally installed apps. It is therefore not necessary to add a root password, once the `--user` flag is added. And this can also be used in conjunction with the other flags below.

----------------------------------------------------
### Install, debug an installation script
The "install.am" module contains some patches to disable long messages. You can see them with the `--debug` flag.

https://github.com/user-attachments/assets/9dd73186-37e2-4742-887e-4f98192bd764

```
am -i --debug {PROGRAM}
am -i --user --debug {PROGRAM}
```
or
```
appman -i --debug {PROGRAM}
```

----------------------------------------------------
### Install the "latest" stable release instead of the latest "unstable"
By default, many installation scripts for apps hosted on github will point to the more recent generic release instead of "latest", which is normally used to indicate that the build is "stable". This is because upstream developers do not always guarantee a certain packaging format in "latest", sometimes they may only publish packages for Windows or macOS, so pointing to "latest" would not guarantee that any package for Linux will be installed.

On the other hand, if you know that the upstream developer will always guarantee a Linux package in "latest" and "AM" instead points to a potentially unstable development version (Alpha, Beta, RC...), this is the syntax to adopt.
```
am -i --force-latest {PROGRAM}
am -i --user --force-latest {PROGRAM}
```
or
```
appman -i --force-latest {PROGRAM}
```

https://github.com/user-attachments/assets/ee29adfd-90e1-46f7-aed9-b9c410f68776

----------------------------------------------------
### Install and Sandbox AppImages
Since version 9.3 it is possible to use the "`--sandbox`" flag to sandbox only AppImages during the installation process
```
am -i --sandbox {PROGRAM}
am -i --user --sandbox {PROGRAM}
```
or
```
appman -i --sandbox {PROGRAM}
```

![Istantanea_2024-12-02_03-50-43-2](https://github.com/user-attachments/assets/da90b4ea-f199-469c-b2a3-e410577f3847)

...note that sandboxing only works for AppImages (see "[Sandboxing](./sandbox.md)"), for other programs it will not work.

NOTE, **it is recommended to use the `-i --sandbox` combination only if you have local and custom scripts to install.**

If you rely on the AppImages listed in the "AM" database, use the `-ia --sandbox` combination or even better `-ias` (Install AppImage & Sandox).

See more at "[Install only AppImages](./install-appimage.md)".

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
