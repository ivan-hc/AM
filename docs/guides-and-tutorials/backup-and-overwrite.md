## Backup and restore installed apps using snapshots

### Backup
Option `-b` or `backup` creates a copy of the installed app into a dedicated directory under $HOME/.am-snapshots.
```
am -b {PROGRAM}
```
This command will present you with 3 possible options for naming your snapshot:
- by default, just press ENTER to use the classic mix date+time of the snapshot creation;
- if you press "**1**", the snapshot version will be used as the name;
- finally, you can simply write the name to give to the snapshot (spaces will be replaced with a "`_`").

A final message will also indicate the name of the just created snapshot.

NOTE that a check has been added to verify if a directory with the same name already exists. In that case you get an error. **You can't have two snapshots with the same name**, of course.

The above three cases are shown **in the screenshot below**, with the following results:
1. in the first attempt I chose to use the version as the name, but it gave me error because the directory already existed;
2. in the second instead I left it empty, thus creating a snapshot based on the date and time (default);
3. finally I gave a custom name using a phrase with a space.

![Istantanea_2024-10-16_15-40-29 png](https://github.com/user-attachments/assets/da6f3aec-b2cf-4186-babe-f5ebf4985cd0)

### Restore
In the use that we will make of it, through the option `-o` or `overwrite`, we will have a result like this.
```
am -o {PROGRAM}
```

![Istantanea_2024-10-16_15-44-55 png](https://github.com/user-attachments/assets/92d8fdf0-96d0-4447-8c39-21860654a5bf)

### How to use multiple versions of the same application
You can use the `-b` option for snapshots, and where applicable, you can use the `downgrade` or `--rollback` option to install older versions of a program. This way, whenever you want to use a different version of the same program, you can use `-o`, using the snapshot you prefer.

For example, suppose you want to alternate "Kdenlive 24.08.1" (at the time of writing, it is the latest release available) with "Kdenlive 23.08" which still supports QT5, here's how to do it:
1. do a backup with `am -b kdenlive`, press `y` and press `1`, this will create the snapshot "24.08.1";
2. run the command `am downgrade kdenlive` and select the version 23.08 from the list;
3. run a backup again with `am -b kdenlive`, press `y` and press `1` to create the snapshot "23.08";
4. from now on, to switch between them, just use `am -o kdenlive` and select between "24.08.1" and "23.08", from the list.

You can create as many snapshots as you want and switch them this way according to your needs!

And if it is an AppImage, you can dedicate its own .home and .config directories to it (option `-H` and `-C`, respectively, in uppercase).

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
