## Install only AppImages
All suboptions for `-i`/`install` listed above can be used to install AppImages only, it is enough to use the option `-ia`/`install-appimage`:
```
am -ia {PROGRAM}
am -ia --debug {PROGRAM}
am -ia --force-latest {PROGRAM}
```
or
```
appman -ia {PROGRAM}
appman -ia --debug {PROGRAM}
appman -ia --force-latest {PROGRAM}
```
In this example, I'll run the script `brave-appimage` but running `brave`, that instead is the original upstream package:

https://github.com/user-attachments/assets/b938430c-ec0b-4b90-850f-1332063d5e53

in the video above I first launch a "query" with the `-q` option to show you the difference between `brave` and `brave-appimage`, and then `-q --appimages` to show you only the appimages from the list.

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |