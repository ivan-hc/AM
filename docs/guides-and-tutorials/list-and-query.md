## List and query all the applications available on the database
This section covers the procedures for consulting the lists of applications available in this database and on third-party ones.

### List
Option `-l` or `list` shows the whole list of apps available in this repository and on third-party ones.

This option uses `less` to show the list, so to exit its enough to press "**Q**".

By default, only apps available on this repository are shown
```
am -l
```

https://github.com/user-attachments/assets/8862ffc4-0c4f-434d-8a5c-9c6da283cd7c

To see only the AppImages from this list, use the `--appimages` flag
```
am -l --appimages
```

https://github.com/user-attachments/assets/06de5e75-a7e4-49c1-8a1a-a5ce7265502d

To see all the programs available in all the supported databases, use the `--all` flag instead
```
am -l --all
```

https://github.com/user-attachments/assets/e629d1c3-97d7-4147-ac77-05ab19c8675c

As you may have guessed, the lists are very long. However, you can use the `-q` or `query` option to search them, using the same flags. See below.

To view only the list of a third-party database, use the dedicated flag (run `am -h` and see the bottom of the message to see all third-party flags).

### Query
Option `-q` or `query` shows search results from the lists above.

https://github.com/user-attachments/assets/1b2f3f3b-fe22-416f-94d8-d5e0465b3f6d

```
am -q {KEYWORD}
am -q --all {KEYWORD}
am -q --appimages {KEYWORD}
am -q --pkg {PROGRAM1} {PROGRAM2}
```

If followed by `--appimages`, the search results will be only for the available AppImages from the "AM" database.

If followed by `--pkg`, all keywords will be listed also if not on the same line. This is good if you are looking for multiple packages among the ones available in the "AM" database.

If sollowed by `all`, the search results will be from all supported databases.

NOTE, third-party flags from `-l` and `-i` can be used as a keyword after the `--all` flag.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
