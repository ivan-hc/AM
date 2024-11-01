### Integrate local AppImages into the menu by dragging and dropping them
If you are a user who is used to dragging your local AppImages scattered around the system and if you are a user who likes clutter and wants to place their packages in different places... this option is for you.

The option `--launcher` allows you to drag and drop a local AppImage to create a launcher to place in the menu, like any other classic AppImage helper would... but in SHELL.

This option also allows you to create a symbolic link with the name you prefer, in "`~/.local/bin`". Leave blank to let the option create a shell script that calls your AppImage, with extension ".appimage", lowercased.

##### How to create a launcher for a local AppImage
```
am --launcher /path/to/File.AppImage
```
or
```
appman --launcher /path/to/File.AppImage
```
In this video I'll integrade Brave AppImage, the first time without a name, and the second time by choosing "brave" (NOTE, the ".appimage" in $PATH is a little shell script that calls the AppImage, not the whole AppImage):

https://github.com/user-attachments/assets/caa22ab7-b6a4-45c4-bd33-27316251e267

Now the binaries are "two", keep read to see how to remove them using "AM" and "AppMan".

##### How to remove the orphan launchers
In case you move your AppImages somewhere else or remove them, use the following otion `-c` or `clean` to get rid of all the orphaned launchers and dead symlinks and scripts you created earlier:
```
am -c
```
or
```
appman -c
```
In this video I'll remove the AppImage, and then I'll remove the launchers and items in $PATH created in the previous video (see above):

https://github.com/user-attachments/assets/2dedf1a9-43c2-455c-8c97-2023bedc4203

##### AppImages from external media
Another peculiarity concerns the use of the `-c` option on launchers created on AppImage packages placed on removable devices:
- if in the .desktop file belongs to an AppImage placed in /mnt or /media and none of the references are mounted, the option `-c` will not be able to remove it until you mount the exact device where it was placed in the moment you have created the launcher;
- if you mount that same device and the AppImage is not where it was when you created the launcher, it will be removed.

This is very useful if you have large AppImage packages that you necessarily need to place in a different partition.

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |