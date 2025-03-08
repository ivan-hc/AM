## Install only AppImages
To install AppImages only, it is enough to use the `-ia`/`install-appimage` option.
```
am -ia {PROGRAM}
am -ia --user {PROGRAM}
```
All flags for the `-i`/`install` option can be used here as well.
```
am -ia --debug {PROGRAM}
am -ia --force-latest {PROGRAM}
am -ia --sandbox {PROGRAM}
```
Same for AppMan.
```
appman -ia {PROGRAM}
appman -ia --debug {PROGRAM}
appman -ia --force-latest {PROGRAM}
appman -ia --sandbox {PROGRAM}
```
In this example, I run the script `brave-appimage` but running `brave`, that instead is the original upstream package.

https://github.com/user-attachments/assets/b938430c-ec0b-4b90-850f-1332063d5e53

In the video above, before proceeding I use the command `am -q` and `am -q --appimages` to show the difference between `brave` and `brave-appimage` in the lists.

------------------------------------------------------------------------
## Install and sandbox AppImages in one go
There is also a declination of `-ia`, namely `-ias` (Install AppImage & Sandox) which is equivalent to `-ia --sandbox` to start the sandbox configuration process via Aisap/Bubblewrap at the end of each installation
```
am -ias {PROGRAM}
am -ias --user {PROGRAM}
```
or
```
appman -ias {PROGRAM}
```

https://github.com/user-attachments/assets/151b5400-415c-48c5-81dd-65a7be1a9b06

NOTE, **`-ia --sandbox` and `-ias` are only for the AppImages listed in the "AM" database!**

To Install and Sandbox other AppImages from local scripts and third-party/custom databases, **use the `-i --sandbox` combination instead**
```
am -i --sandbox {PROGRAM}
am -i --user --sandbox {PROGRAM}
```
or
```
appman -i --sandbox {PROGRAM}
```
Sandboxing of other formats is not supported.

See also how sandboxing works in "AM", at "[Sandboxing](./sandbox.md)".

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
