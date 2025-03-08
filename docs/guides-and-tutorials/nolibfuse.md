## Convert Type2 AppImages requiring libfuse2 to New Generation AppImages
Option `nolibfuse` converts old Type2 AppImages asking for "libfuse2" into new generation AppImages:
```
am nolibfuse $PROGRAM
```
or
```
appman nolibfuse $PROGRAM
```
in this example, I'll convert Libreoffice and Kdenlive:

https://github.com/user-attachments/assets/494d0d92-f46c-4d4e-b13d-f1d01168fb8f

As you can see, the file sizes are also smaller than before.

This process only works for old AppImages that still depend on "libfuse2", other files will be ignored.

The original AppImage will be extracted using the `--appimage-extract` option, and then repackaged using `appimagetool` from https://github.com/AppImage/appimagetool 

#### Updating converted AppImages
The `nolibfuse` option adds the following lines at the end of the AM-updater script
```
echo y | am nolibfuse $APP
notify-send "$APP has been converted too! "
```
or
```
echo y | appman nolibfuse $APP
notify-send "$APP has been converted too! "
```
so if an update happens through "comparison" of versions, the converted AppImage will be replaced by the upstream version and then the `nolibfuse` option will automatically start the conversion (prolonging the update time, depending on the size of the AppImage). In this example, I update all the apps, including the original Avidemux, that is an old Type2 AppImage:

https://github.com/user-attachments/assets/03683d8b-32d8-4617-83e3-5278e33b46f4

Instead, if the installed AppImage can be updated via `zsync`, **this may no longer be updatable**, anyway a solution may be the use of `appimageupdatetool`, at https://github.com/AppImageCommunity/AppImageUpdate .

The `nolibfuse` option has been improved since version 7.8, so everyone can say goodbye to the old "libfuse2" dependence.

Anyway, **I suggest anyone to contact the developers to update the packaging method of their AppImage!** This is also a way to keep open source projects alive: your participation through feedback to the upstream.

The `nolibfuse` option is not intended to replace the work of the owners of these AppImage packages, but to encourage the use of AppImage packages on systems that do not have "libfuse2", a library that is now obsolete and in fact no longer available out-of-the-box by default in many distributions, first and foremost Ubuntu and Fedora.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------