## Using "AM" on freeBSD and derivatives

Since version 9.4, "AM" is compatible with BSD-based systems.

However, the compatibility of Linux programs on your BSD system must be done manually.

There are several guides on this subject, the one available on the FreeBSD site is an example https://docs.freebsd.org/en/books/handbook/linuxemu, but I will try to adapt [this one](https://unixdigest.com/tutorials/how-to-install-signal-desktop-on-freebsd-using-the-linux-binary-compatibility.html) as much as possible to the use of Debian in `debootstrap`, which is the most familiar distribution for me.

------------------------------------------------------------------------
## Getting started
First we need to enable the Linux compatibility layer:
```
# sysrc linux_enable="YES"
```
Once enabled, it can be started without rebooting by executing the following command:
```
# service linux start
```
Then we need to install and use debootstrap, a program that can be used to install different Debian versions in a system without using an installation disk.
```
# pkg install debootstrap
```
Then we need to setup the correct installation path for debootstrap. Use your favorite text editor and insert the following line in /etc/sysctl.conf:
```
compat.linux.emul_path="/compat/debian"
```
Then we use debootstrap to install the Debian base tools for the Debian Bookworm version:
```
# debootstrap stable /compat/debian
```
In order for the contents of the home directory to be shared and in order to be able to run X11 applications, the directories /home and /tmp should be mounted in the Linux compat area using nullfs for loopback.

Edit /etc/fstab and insert the following:
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
Then execute mount in order to mount everything:
```
# mount -al
```
Now we're ready to use chroot to access the Linux system:
```
# chroot /compat/debian /bin/bash
```
We can use the uname command to verify that we are located in a Linux environment:
```
# uname -b
Linux 6.1.119 x86_64
```
Exit the chroot environment by typing exit
```
exit
```
...and edit and update the APT repositories located in /compat/debian/etc/apt/sources.list:
```
deb https://deb.debian.org/debian stable contrib main
deb https://deb.debian.org/debian stable-updates contrib main
deb https://deb.debian.org/debian stable-backports contrib main
deb https://deb.debian.org/debian-security stable-security contrib main
```
I also prefer to disable recommended and suggested packages in /compat/debian/etc/apt/apt.conf:
```
APT::Install-Recommends "false";
APT::AutoRemove::RecommendsImportant "false";
APT::AutoRemove::SuggestsImportant "false";
```
Then we go back into the chroot environment and update APT:
```
# chroot /compat/debian /bin/bash
# apt update
```
If you get a lot of packages that need upgrading, you can do that before you continue with:
```
# apt full-upgrade
```
Exit the chroot and run a program you have installed using "AM"/"AppMan" and check the error messages for missing libraries and packages.

If you have any doubts, install those packages that end with "-dev", so you can be sure you have all the libraries needed to run these programs.

To install them, enter the chroot again and install the missing dependencies with APT
```
# chroot /compat/debian /bin/bash
# apt install {package}
```
The list of packages to add is still to be found. In the meantime I invite you to read what will be added gradually in the "Troubleshoots" section below the tips to make the best work the programs for Linux on BSD, including the packages installable via APT.

------------------------------------------------------------------------
## Troubleshooting
This section lists common problems that may arise. "AM" does not guarantee miracles.

### ELF interpreter error
If you get the error:
```
ELF interpreter /lib64/ld-linux-x86-64.so.2 not found, error 2
```
Then fix this by doing the following as root outside the chroot:
```
# cd /compat/debian/lib64/
# rm ./ld-linux-x86-64.so.2
# ln -s ../lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 ld-linux-x86-64.so.2
```
Then run again the program installed with "AM"/"AppMan" as the regular user.

If the problem with ld-linux-x86-64.so.2 persists, then reboot FreeBSD before you continue.

### Chromium-based applications
Run Chromium-based apps with the `--no-sandbox` flag, for example
```
$ brave --no-sandbox
```

### FUSE
AppImages require FUSE to work.

For older implementations (which are still the most popular) install with APT `libfuse2` or `libfuse2t64` (depending on the package made available in the repositories), while for all implementations, even the most recent ones, install `fuse3` and later (the latter brings with it `fusermount`).
```
# apt install libfuse2 fuse3
```

### GTK3
Some programs, even those not in AppImage format, such as Firefox and Thunderbird, require the GTK3 libraries to run. Install the `libgtk-3-dev` package via APT.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
