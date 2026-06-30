## Clone a configuration and export it to other systems
The `clone` or `--clone` option allows you to detect or create a file called "am-clone.source" from which AM/AppMan can obtain the information needed to install apps from one system to another. This allows you to choose whether to keep distinct system and local installations, or whether to install everything system-wide or locally.

File detection starts (in order of priority):
1. from the XDG_DESKTOP_DIR directory (usually Desktop)
2. from the HOME directory (any directory except Thrash)
3. from the entire system, starting from the root, and then from mounted devices (in case you want to install a configuration via USB stick)

If you want to create a new "am-clone.source" file, simply remove the other one or rename it.

**This option supports both AM and third-party databases.**

The basic command is
```
am clone
```
without arguments. This allows you to read the list.

<img width="747" height="582" alt="Istantanea_2025-09-18_16-02-20" src="https://github.com/user-attachments/assets/cbc497ea-5a95-4568-8a48-6d3199a057b6" />

By default, the new file is created in XDG_DESKTOP_DIR, or HOME as a fallback. It contains "dummy" paths to allow AM/AppMan to distinguish between locally and system-wide installed apps (depending on whether the line starts with /opt or not).

You can also set a different file by exporting the "$CLONE_FILE" variable and specifying a path and a text file with a different name, for example
```
export CLONE_FILE="/path/to/your/file.txt"
```
But make sure the paths begin with /opt if you want system installations.

But what we've seen so far is just a basic way to view and/or create/use the list.

The new `clone` option also supports flags.

To install the listed apps in their original layout, run
```
am clone -i
```
or
```
am clone install
```
A confirmation prompt will appear.

<img width="747" height="582" alt="Istantanea_2025-09-18_16-10-42" src="https://github.com/user-attachments/assets/226d9259-7f46-4076-9cbb-c3cab6594163" />

In AM, to install everything locally like AppMan, add the `--user` flag
```
am clone -i --user
```

<img width="747" height="582" alt="Istantanea_2025-09-18_16-12-38" src="https://github.com/user-attachments/assets/ff8ee528-ca65-4ebc-96ed-ff7b7b025a2a" />

While to install everything at system level, add the `--system` flag
```
am clone -i --system
```

<img width="747" height="582" alt="Istantanea_2025-09-18_16-14-02" src="https://github.com/user-attachments/assets/4927e4f6-9b03-4283-b6c4-edd41bffacbe" />

Of course, AppMan only supports local installations, no apps will require root privileges or system installations.

NOTE: On existing configurations, already installed apps will NOT be overwritten.

NOTE2: Reinstalled apps don't retain any sandboxes, isolation directories, or other manual changes made by the user. Consider using the `backup`/`-b` and `overwrite`/`-o` options for this purpose. See [here](./backup-and-overwrite.md).

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
