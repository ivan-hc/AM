## Change the destination path of installed programs
In AM, programs are always installed in /opt, following the LSB (Linux Standard Base) [specifications](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s13.html). It is not possible to change this path.

In contrast, AppMan and "AM" in AppMan mode can install all programs locally or in non-privileged locations, chosen by the user. No root password is required for this.

The path chosen at first launch is specified in the $XDG_CONFIG_HOME/appman/appman-config file. Editing this file directly disconnects AM and AppMan from that location, thus removing any interaction with locally installed programs.

Furthermore, installed programs all have a symbolic link and (often) a .desktop file, which breaks if the program directory is moved.

The only solution is to run the `relocate` or `--relocate` option, which will allow you to:
1. Identify local apps installed, even from third-party databases
2. Remove these apps, noting the scripts used to install them
3. Choose a different location to install the apps
4. Reinstall the previously removed apps in the new location indicated

All this requires your confirmation in the prompt that appears.

Just run
```
am relocate
```
or
```
am --relocate
```
or
```
appman relocate
```
or
```
appman --relocate
```

https://github.com/user-attachments/assets/1b721a62-a8eb-43df-9d2f-e5f7a0c4f63d

NOTE: On existing configurations, already installed apps will NOT be overwritten.

NOTE2: Reinstalled apps don't retain any sandboxes, isolation directories, or other manual changes made by the user. Consider using the `backup`/`-b` and `overwrite`/`-o` options for this purpose. See [here](./backup-and-overwrite.md).

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
