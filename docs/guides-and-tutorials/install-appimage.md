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
am -ia --user --debug {PROGRAM}
am -ia --user --force-latest {PROGRAM}
```
Same for AppMan.
```
appman -ia {PROGRAM}
appman -ia --debug {PROGRAM}
appman -ia --force-latest {PROGRAM}
```
In this example, I run the script `brave-appimage` but running `brave`, that instead is the original upstream package.

https://github.com/user-attachments/assets/b938430c-ec0b-4b90-850f-1332063d5e53

In the video above, before proceeding I use the command `am -q` and `am -q --appimages` to show the difference between `brave` and `brave-appimage` in the lists.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
