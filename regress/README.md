## AM Regression Testing
This page explains in detail on how to use the AM regression testing suite.
It is a POSIX sh compliant test flow that can be run independently by testers on their systems to help with regression testing AM's features.
They will display either pass or fail at the end of the test, and can help find bugs in the dev branch of AM.
All scripts are **POSIX sh compliant** and will properly run in any OS.

The following is a brief explanation for the files in the regression dir:
- `test-common.sh`
  - Houses all common functions for all tests.
  - Contains TEST_APP_LIST* that has a list of predefined apps to be randomly selected for testing.
  - All apps in the test list are selected to be small downloads, and do not have complex install scripts.
- `test-am-*.sh` - Performs a POSIX sh compliant structured AM test to check for a specific function/feature. Test sequence depends on the contents of the test file.
- `test-am-regress.sh` - Runs all of the available regression tests in one go. May take a while to complete.
- `am-*.dockerfile` - Needed for building a container image based on the selected OS (eg. Debian or Ubuntu), with the correct environment setup for testing. AM will work out-of-the-box.

While these tests can be directly run on your main OS, **do not attempt this**. Running them may produce very undesirable artifacts, such as installing unnecessary apps in your system, or uninstalling all apps, switching AM modes, etc. Instead, it is strongly recommended to run them in a Podman/Docker container instead.

----------------------------------------------------
#### How to start testing AM in a safe container environment
Podman is recommended for AM testing because it does not require sudo/root (rootless), whereas Docker or a traditional VM will require it.
It will allow you to perform the tests in an isolated and controlled environment, without messing up your main OS.
The provided dockerfiles will allow you to quickly/easily build these test container images with all the needed dependencies.

Steps to begin regression testing:
1. Make sure Podman is installed, eg. for Debian:\
`sudo apt install podman`\

2. Clone the AM repo and go to the regression dir:\
`git clone https://github.com/ivan-hc/AM`\
`cd AM/regress`

3. Build am-debian container image:\
`podman build --platform linux/x86-64 -t am-debian -f am-debian.dockerfile`\
Alternatively, you may select a different container image such as am-ubuntu:\
`podman build --platform linux/x86-64 -t am-ubuntu -f am-ubuntu.dockerfile`

4. Start am-debian container session in default mode (persistent Appimages):\
`podman run -it --platform linux/x86-64 --device /dev/fuse --cap-add SYS_ADMIN --security-opt unmask=ALL am-debian:latest`\
Alternatively, start am-debian container session with tmpfs for Appimage dirs (stores in RAM to avoid wearing out your SSD):\
`podman run -it --platform linux/x86-64 --device /dev/fuse --cap-add SYS_ADMIN --security-opt unmask=ALL --tmpfs /opt --tmpfs /root/.local/share/applications am-debian:latest`\
**You will now be inside the container**.

5. Setup AM as needed (eg. switch to dev branch):\
`am --devmode-enable`

6. Run all regression tests:\
`./test-am-regress.sh`\
Alternatively, run individual tests:\
`./test-am-checksum.sh`\
`./test-am-install.sh`

The AM tests will execute within the container's environment. It will not affect your main OS, so it is completely safe for testing.

Running a container with *tmpfs* for Appimage install directories is useful for testing the installation of large apps repeatedly without wearing out the SSD drive. But make sure you have enough RAM in your system to handle this.

Stopping/exiting the container with *tmpfs* for Appimage install directories will instantly release the used RAM and the installed Appimages in the container will be lost. However, non-Appimage related directories are not affected, changes to them will be persistent as expected.

----------------------------------------------------
#### Running an emulated ARM 64-bit (aarch64) AM test container
To start an ARM 64-bit podman container on your PC, QEMU must be used on the host machine to emulate the system. The am-alpine test container works well for this purpose, but the other available containers may also work.

1. Make sure QEMU and the following packages are installed in your host machine, eg. for Debian:\
`sudo apt install qemu-user-static binfmt-support`

2. Make sure to set the `--platform linux/arm64` option to select aarch64 correctly when building and running a container:\
`podman build --platform linux/arm64 -t am-alpine-arm64 -f am-alpine.dockerfile`\
`podman run -it --platform linux/arm64 --device /dev/fuse --cap-add SYS_ADMIN --security-opt unmask=ALL am-alpine-arm64:latest`

It is normal for an aarch64 container to run slightly slower than usual due to the fact that the host machine will need to emulate an ARM 64-bit processor.

Also, remember to set a unique image name (eg. `-t am-alpine-arm64`) so that it does not conflict with the regular x86-64 version.

----------------------------------------------------
#### Podman usage cheatsheet

List running containers:\
`podman ps -a`

Start a stopped container:\
`podman start -a <NAME/ID>`

Force stop (kill) a running container:\
`podman kill <NAME/ID>`

Remove a stopped container:\
`podman rm <NAME/ID>`

Copy a test file from system into a container:\
`podman cp test-am-new.sh <NAME/ID>:/root/regress/.`

List downloaded/built images:\
`podman images`

Remove a downloaded/built image:\
`podman rmi <NAME/ID>`

Download an image (eg. latest version of Debian):\
`podman pull docker.io/debian:latest`

Run the latest Debian image (it will auto start):\
`podman run -it debian:latest /bin/bash`

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../README.md#guides-and-tutorials) | [Back to "Main Index"](../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
