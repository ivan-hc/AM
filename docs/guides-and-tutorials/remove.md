## Remove one or more applications
Option `-R` removes the selected apps without asking
```
am -R {PROGRAM}
```

https://github.com/ivan-hc/AM/assets/88724353/4d26d2d7-4476-4322-a0ab-a0a1ec14f751


To have a prompt, use `-r` or `remove`, lowercased
```
am -r {PROGRAM}
```
This is possible thanks to the script called `remove` present in the directory of all installed apps, and which is the first file to be created during the installation process.

If an app is installed at the system level, in `/opt`, it will be necessary to use the root password to start the script.

## How to update or remove apps manually
This section covers some cases where you can manage installed apps via "AM" but without "AM".

#### Manually removing a program
To remove an application without using "AM", simply run the `remove` script, use root privileges if the app is installed system-wide
```
sudo /opt/{PROGRAM}/remove
```
or run the script directly if the app is installed unprivileged
```
/path/to/unprivileged/directory/{PROGRAM}/remove
```
and just as there is a `remove` file, many (not all) installed programs have an `AM-updater` script, which is instead intended to update the installed app.

#### Manually Update
Since the owner of "AM" is the only one who has write permissions for apps installed in `/opt`, he/she can simply run the script like this
```
/opt/{PROGRAM}/AM-updater
```
other non-privileged users will have to use root privileges.

Non-privileged users can however use AppMan.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
