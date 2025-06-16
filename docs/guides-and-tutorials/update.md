## Update
Option `-u` or `update` updates all the installed apps and keeps "AM"/"AppMan" in sync with the latest version and all latest bug fixes.

https://github.com/user-attachments/assets/662d8eb2-38d7-45b8-9530-061189e6ed85

To update everything, run
```
am -u
```
Add "--apps" to update only the apps or write only the apps
```
am -u --apps
```
Add the name of one or more installed apps to update only them
```
am -i {PROGRAM}
```

## Sync
The `-s` or `sync` option is a part of the update process, and exactly what happens after the applications are updated.

It is responsible for:
1. checking if the installation scripts in the database are the same as those previously used by the user at the time of installation, in order to report if there was any change in the script (change of app source, improved integration, fixed a bug related to the extraction of the app...);
2. updating the "AM" modules
3. updating "AM" itself
of can be run separately:
```
am -s
```
NOTE, the user who installs "AM" owns the directory `/opt/am` and all the apps installed at the system level. If a non-privileged user tries to run `-u` or `-s`, points 2 and 3 will not be started, as they are read-only, so "AM" and the modules will not be updated.

Non-privileged users can however use AppMan.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
