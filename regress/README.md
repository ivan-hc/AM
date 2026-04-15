## AM Regression Testing
This page explains in detail on how to use the AM regression testing suite.
It is a POSIX sh compliant test flow that can be run independently by testers on their systems to help with regression testing AM's features.
They will display either pass or fail at the end of the test, and can help find bugs in the dev branch of AM.
All scripts are **POSIX sh compliant** and will properly run in any OS.

The following is a brief explanation for the files in the regression dir:
- `test-common.sh`
  - Houses all common functions for all tests.
  - Contains TEST_APP_LIST* that contains a list of predefined apps to be randomly selected for testing.
  - All apps in the test list are selected to be small downloads, and do not have complex install scripts.
- `test-am-*.sh` - Performs a POSIX sh compliant structured AM test to check for a specific function/feature. Test sequence depends on the contents of the test file.
- `am-*.dockerfile` - Needed for building an OS (eg. Debian or Ubuntu) container image with the correct environment for testing. AM will be properly setup to work out-of-the-box.

----------------------------------------------------
#### How to start testing AM in a safe container environment
Podman (recommended) or Docker must be installed in your system in order to perform the tests in an isolated and controlled environment, without messing up your main OS.
The provided dockerfiles will allow you to build a container image in your system, which you can then start and use for testing.
AM will run in the container and will not affect your main OS, so it is completely safe for testing.

Test steps (replace podman with docker if needed):
1. Clone AM repo and go to regression dir:\
`git clone https://github.com/ivan-hc/AM`\
`cd AM/regress`
3. Build am-debian container image:\
`podman build -t am-debian -f am-debian.dockerfile`\
Alternatively, you may select a different container image such as am-ubuntu:\
`podman build -t am-ubuntu -f am-ubuntu.dockerfile`
4. Start am-debian container session in default mode (persistent Appimages):\
`podman run -it --device /dev/fuse --cap-add SYS_ADMIN am-debian:latest`\
Alternatively, start am-debian container session with tmpfs for Appimage dirs (stores in RAM to avoid wearing out your SSD):\
`podman run -it --device /dev/fuse --cap-add SYS_ADMIN --tmpfs /opt --tmpfs /root/.local/share/applications am-debian:latest`
5. Run tests (already copied into container):\
`./test-am-checksum.sh`\
`./test-am-install.sh`

Running a container with *tmpfs* for Appimage install directories is useful for testing the installation of large apps repeatedly without wearing out the SSD drive. But make sure you have enough RAM in your system to do this type of stress testing. Exiting the container will instantly release the used RAM and the installed Appimages in the container will also be lost. Other non-Appimage install directories are not affected, changes to them will be persistent.

----------------------------------------------------
#### Podman usage cheatsheet

List running containers:\
`podman ps -a`

Start a stopped container:\
`podman start -a <NAME/ID>`

Remove a stopped container:\
`podman rm <NAME/ID>`

List downloaded/built images:\
`podman images`

Remove a downloaded/built image:\
`podman rmi <NAME/ID>`

Download an image (eg. latest version of Debian):\
`podman pull docker.io/debian:latest`

Run the latest Debian image (it will auto start):\
`podman run -it debian:latest /bin/bash`

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
