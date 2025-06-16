## Third-party databases for applications (NeoDB)
Use the option `newrepo` or `neodb` to add new repositories to use instead of this one. This works for both online and offline repositories.

Set a new default repo, use "add" to append the path to a local directory or an online URL:
```
am newrepo add {URL}\{PATH}
```
or
```
appman newrepo add {URL}\{PATH}
```
then use "select" to use it by default:
```
am newrepo select
```
or
```
appman newrepo select
```
a message will warn you about the usage of this repo instead of the default one.

In the screenshot below, I'm adding an offline directory and an online "RAW" fork of "AM"
![Istantanea_2024-08-25_20-10-47](https://github.com/user-attachments/assets/599f1c11-e2dd-4343-ac51-32e0eeb2643f)

Use "on"/"off" to enable/disable it:
```
am newrepo on
am newrepo off
```
or
```
appman newrepo on
appman newrepo off
```
Use "purge" to remove all 3rd party repos:
```
am newrepo purge
```
or
```
appman newrepo purge
```
Use "info" to see the source from where installation scripts and lists are taken.
```
am newrepo info
```
or
```
appman newrepo info
```
if no third-party repo is in use, you will see the default URLs from this repo.

![Istantanea_2024-08-25_20-07-54 png](https://github.com/user-attachments/assets/793e64b9-7377-424c-a70e-a83e89c5225c)

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------