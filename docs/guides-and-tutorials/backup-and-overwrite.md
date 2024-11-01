### Backup and restore installed apps using snapshots

#### Backup
Option `-b` or `backup` creates a copy of the installed app into a dedicated directory under $HOME/.am-snapshots. 

- by default, each snapshot is named with the date and time you have done the backup, just leave blank and press ENTER;
- if you press "1", the snapshot version will be used as the name;
- finally, you can simply write the name to give to the snapshot (spaces will be replaced with a "`_`").

https://github.com/user-attachments/assets/cff80e3d-a030-4649-a9ef-280938c2eb94

To restore the application to a previous version, copy/paste the name of the snapshot when the `-o` option will prompt it.

#### Restore
Option `-o` or `overwrite` lists all the snapshots you have created with the option `-o` (see above), and allows you to overwrite the new one:

https://github.com/user-attachments/assets/b11e8a2d-9f94-43a2-8c0b-09b9e173394e

### How to use multiple versions of the same application
You can use the `-b` option for snapshots, and where applicable, you can use the `downgrade` or `--rollback` option to install older versions of a program. This way, whenever you want to use a different version of the same program, you can use `-o`, using the snapshot you prefer.

For example, suppose you want to alternate "Kdenlive 24.08.1" (at the time of writing, it is the latest release available) with "Kdenlive 23.08" which still supports QT5, here's how to do it:
1. do a backup with `am -b kdenlive`, press `y` and press `1`, this will create the snapshot "24.08.1";
2. run the command `am downgrade kdenlive` and select the version 23.08 from the list;
3. run a backup again with `am -b kdenlive`, press `y` and press `1` to create the snapshot "23.08";
4. from now on, to switch between them, just use `am -o kdenlive` and select between "24.08.1" and "23.08", from the list.

You can create as many snapshots as you want and switch them this way according to your needs!

And if it is an AppImage, you can dedicate its own .home and .config directories to it (option `-H` and `-C`, respectively, in uppercase).

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |