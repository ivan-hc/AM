## Downgrade an installed app to a previous version
Use the `--rollback` option or `downgrade` in this way:
```
am --rollback ${PROGRAM}
```
This only works with the apps hosted on Github.

By default, all "snapshot" releases are filtered. "Snapshot" refers to releases whose file has the same name, regardless of the tag.

To also display "snapshot" releases, press "n."

Selecting "zero" (or, in fact, any character that doesn't match a number from the list) and then "ENTER" will stop the process.

Each result is denoted by a number.

**In this example**, we're trying to downgrade the stable version of "Brave" (package `brave`), from https://github.com/ivan-hc/Brave-appimage

This source uploads daily snapshots of each release, so the same package could be replicated and published multiple times.

**At the time of writing**, pressing "n" would return a list of 98 results. Leaving blank or whiting "y" and then pressing "ENTER" would return a shorter list of only 13 results.

https://github.com/user-attachments/assets/8cb14b1c-ed5e-45d8-9798-de02e7b0a602

I want to point out that this example is "**at the time of writing**" because these numbers are expected to increase over time.

In some repositories, pressing "n" can return hundreds of results. In other repositories there is no difference between pressing "n" or leaving the default settings. It all depends on how releases are managed and published.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
