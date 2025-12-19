# The `libfuse2` dependency issue in old AppImages
The "libfuse.so.2" library (also known as "libfuse2") is a system library whose [support ended in January 2019](https://github.com/libfuse/libfuse/releases/tag/fuse-2.9.9). Old AppImages built with the old runtime still depend on it.

Because it is insecure, **many Linux distributions stopped including it by default long ago**, while still maintaining the package in their repositories.

In "AM", to allow old AppImages to run on systems without libfuse2, there are two solutions:
1. The `--sandbox` option, to run the AppImage in a Bubblewrap sandbox (using SAS or Aisap as a frontend), automatically enabling `--appimage-extract-and-run` on each instance. Certainly the safest and most convenient solution.
2. The `nolibfuse` option, which extracts and repackages the AppImage using the new runtime. A harmless solution, but it may impact system resources, depending on the size of the AppImage.

This section focuses on the `nolibfuse` option. For `--sandbox`, [see the dedicated section](./sandbox.md).

NOTE, what's done with the `nolibfuse` option should be done by upstream developers, in their workflows, with all the benefits that come with it, including the ability to include the necessary information in the package to allow delta updates to work with the appropriate tools. "AM" only extracts and repackages the AppImages, replacing the obsolete runtime they included, but if these include information for delta updates, they will be unusable (i.e., the "AM" update will be performed by downloading the AppImage from scratch, instead of the few bits that actually changed).

------------------------------------------------------------------------

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

NOTE, AppImage will lose the ability to receive delta updates, **I suggest anyone to contact the developers to update the packaging method of their AppImage!** This is also a way to keep open source projects alive: your participation through feedback to the upstream.

The `nolibfuse` option is not intended to replace the work of the owners of these AppImage packages, but to encourage the use of AppImage packages on systems that do not have "libfuse2", a library that is now obsolete and in fact no longer available out-of-the-box by default in many distributions, first and foremost Ubuntu and Fedora.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
