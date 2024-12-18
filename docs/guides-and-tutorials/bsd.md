## Using "AM" on freeBSD and derivatives

Since version 9.4, "AM" is compatible with BSD-based systems.

However, the compatibility of Linux programs on your BSD system must be done manually.

There are several guides on this subject, the one available on the FreeBSD site is an example https://docs.freebsd.org/en/books/handbook/linuxemu, but I will try to adapt [this one](https://unixdigest.com/tutorials/how-to-install-signal-desktop-on-freebsd-using-the-linux-binary-compatibility.html) as much as possible to the use of Debian in `debootstrap`, which is the most familiar distribution for me.

I will divide this quick guide highlighting the essential steps

------------------------------------------------------------------------
- [1. Enable Linux Compatibility Layout](#1-enable-linux-compatibility-layout)
- [2. Install Debian layout compatibiliti in BSD](#2-install-debian-layout-compatibiliti-in-bsd)
- [3. Configure and mount the Linux compatibility layout on BSD](#3-configure-and-mount-the-linux-compatibility-layout-on-bsd)
- [4. Configure Debian](#4-configure-debian)
- [5. Chroot Debian](#5-chroot-debian)
- [6. Update Debian](#6-update-debian)
- [7. Install needed packages in Debian](#7-install-needed-packages-in-debian)
- [8. Exit the chroot](#8-exit-the-chroot)
- [9. Fix ELF interpreter error](#9-fix-elf-interpreter-error)
- [10. Allow AppImages to use FUSE without root privileges](#10-allow-appimages-to-use-fuse-without-root-privileges)

- [Troubleshooting](#troubleshooting)
  - [Chromium-based applications](#chromium-based-applications)
  - [Missing libraries](#missing-libraries)

------------------------------------------------------------------------
## 1. Enable Linux Compatibility Layout
First we need to enable the Linux compatibility layer, to do so we need to run these commands **as root**, no reboot needed:
```
sysrc linux_enable="YES"
service linux start
```

------------------------------------------------------------------------
## 2. Install Debian layout compatibiliti in BSD
Then we need to install and use debootstrap, a program that can be used to install different Debian versions in a system without using an installation disk.

As I mentioned at the beginning, I will be using Debian, "Stable" branch

Using the PKG package manager, install "debootstrap"
```
pkg install debootstrap
```
...then we need to setup the correct installation path for debootstrap. Use your favorite text editor and insert the following line in /etc/sysctl.conf
```
compat.linux.emul_path="/compat/debian"
```
...and finally, we use debootstrap to install the Debian base tools for the Debian Stable, **as root**
```
debootstrap stable /compat/debian
```

------------------------------------------------------------------------
## 3. Configure and mount the Linux compatibility layout on BSD
In order for the contents of the home directory to be shared and in order to be able to run X11 applications, the directories /home and /tmp should be mounted in the Linux compat area using nullfs for loopback.

In BSD, edit /etc/fstab and insert the following:
```
# Device        Mountpoint              FStype          Options                      Dump    Pass#
devfs           /compat/debian/dev      devfs           rw,late                      0       0
tmpfs           /compat/debian/dev/shm  tmpfs           rw,late,size=1g,mode=1777    0       0
fdescfs         /compat/debian/dev/fd   fdescfs         rw,late,linrdlnk             0       0
linprocfs       /compat/debian/proc     linprocfs       rw,late                      0       0
linsysfs        /compat/debian/sys      linsysfs        rw,late                      0       0
/tmp            /compat/debian/tmp      nullfs          rw,late                      0       0
/home           /compat/debian/home     nullfs          rw,late                      0       0
```
Then execute mount in order to mount everything, **as root**:
```
mount -al
```

------------------------------------------------------------------------
## 4. Configure Debian
Edit and update the APT repositories located in /compat/debian/etc/apt/sources.list
```
deb https://deb.debian.org/debian stable contrib main
deb https://deb.debian.org/debian stable-updates contrib main
deb https://deb.debian.org/debian stable-backports contrib main
deb https://deb.debian.org/debian-security stable-security contrib main
```
I also prefer to disable recommended and suggested packages in /compat/debian/etc/apt/apt.conf
```
APT::Install-Recommends "false";
APT::AutoRemove::RecommendsImportant "false";
APT::AutoRemove::SuggestsImportant "false";
```

------------------------------------------------------------------------
## 5. Chroot Debian
Now we're ready to use chroot to access the Linux system. **As root**, do
```
chroot /compat/debian /bin/bash
```
Now its time to setup Debian.

------------------------------------------------------------------------
## 6. Update Debian
Keep Debian updated via APT
```
apt update
```
If you get a lot of packages that need upgrading, you can do that before you continue with
```
apt full-upgrade
```

------------------------------------------------------------------------
## 7. Install needed packages in Debian
AppImages require FUSE to work. For older implementations (which are still the most popular) install with APT `libfuse2` or `libfuse2t64` (depending on the package made available in the repositories), while for all implementations, even the most recent ones, install `fuse3` and later (the latter brings with it `fusermount`).
```
apt install libfuse2 fuse3
```
Since they are written for Linux, they will surely require substantial dependencies. The safest way to get them is to install packages that end with "-dev".

For example, "Brave AppImage" requires "`libnss3`", to be sure to use "`libnss3-dev`" instead
```
apt install libnss3-dev
```
...also, "`pulseaudio`" brings with it several core libraries that can be required in different programs
```
apt install pulseaudio
```
...not to mention that many programs, including the official versions of Firefox and Thunderbird, require some GTK3 or earlier libraries
```
apt install libgtk-3-dev libgtk2.0-dev
```
...I also suggest Xorg
```
apt install xorg
```
...if you want to use special fonts, you need to get at least the basic ones
```
apt install fonts-freefont-ttf
```
Is it too much? I know.

The reason for this is that different programs require different libraries on the host, which are almost always present on Linux. This list will continue to be updated until we discover more common packages that may be needed to run the portable Linux programs managed by "AM" and "AppMan".

------------------------------------------------------------------------
## 8. Exit the chroot
To exit the chroot and return to the main BSD shell, you can use the "`exit`" command
```
exit
```

------------------------------------------------------------------------
## 9. Fix ELF interpreter error
To  prevent errors like this one...
```
ELF interpreter /lib64/ld-linux-x86-64.so.2 not found, error 2
```
...do
```
cd /compat/debian/lib64/
rm ./ld-linux-x86-64.so.2
ln -s ../lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 ld-linux-x86-64.so.2
```
This change requires a reboot (as does the next point, which is the most important one for AppImages, so... wait and keep read).

------------------------------------------------------------------------
## 10. Allow AppImages to use FUSE without root privileges
Edit the file /etc/sysctl.conf by adding this line
```
vfs.usermount=1
```
This change requires a reboot.

------------------------------------------------------------------------
## Troubleshooting
This section lists common problems that may arise. "AM" does not guarantee miracles.

### Chromium-based applications
Run Chromium-based apps with the `--no-sandbox` flag, for example
```
$ brave --no-sandbox
```

### Missing libraries
Always check the terminal output, also using `LD_DEBUG=lib` if necessary, to see which libraries a program requires to run.

Search for such libraries in APT, also with `apt search {keyword}` or by searching on the internet, to locate the package to install.

Remember to always chroot to install packages via APT
```
chroot /compat/debian /bin/bash
apt install {package}
```

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
