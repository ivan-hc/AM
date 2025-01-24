## Sandbox an AppImage
This page explains in detail how AppImage sandboxing works individually in "AM". To apply them during installation, go to the related guide "[Install and sandbox AppImages in one go](./install-appimage.md#install-and-sandbox-appimages-in-one-go)" instead.

Since version 6.12, "AM"/"AppMan" uses Bubblewrap for sandboxing AppImage packages, thanks to "[Aisap](https://github.com/mgord9518/aisap)", a highly intuitive and configurable command line solution.

The option "`--sandbox`", which since version 5.3 was using Firejail, has taken on a completely different appearance and usability, thanks to the intense work of @Samueru-sama, who managed to extend and enhance "Aisap", making it extremely easy to use in our project, to the point of making us forget that we are using a command line utility.

[Bubblewrap](https://github.com/containers/bubblewrap) is an highly used sanboxing solution, used in multiple projects for GNU/Linux, including Flatpak.

In this sense, "Aisap" may be considered a reference point for the future of AppImages sandboxing!

----------------------------------------------------
#### How to enable a sandbox
This method works as follows:
```
am --sandbox $APP
```
or
```
appman --sandbox $APP
```
The "aisap" package installed is required, whether it is available system-wide ("AM") or locally ("AppMan"), the important thing is that the "aisap" command is in $PATH. If it is not present, "AM"/"AppMan" will ask you if it can proceed with the installation before continuing.

We will first compile the Aisap script in a non-privileged, easy-to-access directory, before being placed in $PATH (see step 2, below).
1. Once started, you will be asked whether to enable the sandbox (default "Y") or not (type "N"):
  - the main XDG directories (Pictures, Videos, Documents...) will be listed, answer whether to authorize access (type "Y") or not ("N", default);
  - at the end, choose whether to specify some directories to access (default "N"), and if "Yes", write the path.
2. Now that the script is complete, it should be placed in $PATH. "AM" users will need to authorize writing to /usr/local/bin by entering their password. "AppMan" users do not have these problems;
3. To allow Aipman take care of the AppImage, the latter be set to "not executable" and the related AM-updater will also have its `chmod` command set from `a+x` to `a-x`.
4. Now your AppImage is in a sandbox!

NOTE, the default location for the sandboxed homes is at $HOME/.local/am-sandboxes, but that location can be changed by setting the $SANDBOXDIR environemt variable.

----------------------------------------------------
#### How to disable a sandbox
To remove the sandbox just run the command of the AppImage with the flag "--disable-sandbox", like this:
```
$APP --disable-sandbox
```
To disable sandboxes from one or more apps at once use "AM"/"AppMan" instead:
```
am --disable-sandbox $APP1 $APP2 $APPN
appman --disable-sandbox $APP1 $APP2 $APPN
```

----------------------------------------------------
#### Sandboxing example
In the video below we will use "Baobab" (GTK3 version), a disk space analyzer, available in the database as "baobab-gtk3".

Among the XDG directories we will authorize "Images" (Pictures) and "Videos" (Videos), while manually we will authorize "Public". The test will be carried out in normal mode, then in sandbox and again without sandbox:

https://github.com/ivan-hc/AM/assets/88724353/dd193943-7b08-474a-bbbb-4a6906de8b24

----------------------------------------------------
#### About Aisap sandboxing
For more information about "Aisap", visit https://github.com/mgord9518/aisap

Available profiles are listed at https://github.com/mgord9518/aisap/tree/main/profiles

To learn more about permissions, see https://github.com/mgord9518/aisap/tree/main/permissions

EXTRA: The behavior of this option can be tested in a completely standalone way by consulting the repository of its creator, at [Samueru-sama/aisap-am](https://github.com/Samueru-sama/aisap-am)

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
