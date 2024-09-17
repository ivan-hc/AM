## List and query all the applications available on the database
This section covers the procedures for consulting the lists of applications available in this database and on third-party ones.

### List
Option `-l` or `list` shows the whole list of apps available in this repository and on third-party ones.

This option uses `less` to show the list, so to exit its enough to press "**Q**".

By default, only apps available on this repository are shown
```
am -l
```
https://github.com/user-attachments/assets/f020316f-711c-4086-8ba8-d611f7c7a03d

To see only the AppImages from this list, use the `--appimages` flag
```
am -l --appimages
```
https://github.com/user-attachments/assets/7c52d373-78ae-4f8e-b053-d212ae84b55a

To see only the programs available on the Toolpacks repository, add the `--toolpack` flag
```
am -l --toolpack
```
https://github.com/user-attachments/assets/cb20003d-02bc-419f-8ffe-80c17b915ea8

To see all the programs available in all the supported databases, use the `--all` flag instead
```
am -l --all
```
https://github.com/user-attachments/assets/02d24f0c-0a7a-4c69-8463-59cf00e75cd1

As you may have guessed, the lists are very long. However, you can use the `-q` or `query` option to search them, using the same flags. See below.

### Query
Option `-q` or `query` shows search results from the lists above.

https://github.com/user-attachments/assets/1b2f3f3b-fe22-416f-94d8-d5e0465b3f6d

```
am -q {KEYWORD}
am -q --all {KEYWORD}
am -q --appimages {KEYWORD}
am -q --toolpak {KEYWORD}
am -q --pkg {PROGRAM1} {PROGRAM2}
```

If followed by `--appimages`, the search results will be only for the available AppImages from the "AM" database.

If followed by `--pkg`, all keywords will be listed also if not on the same line. This is good if you are looking for multiple packages among the ones available in the "AM" database.

If followed by `--toolpack`, the search results will be only for available programs from the "Toolpacks" database.

If sollowed by `all`, the search results will be from all supported databases.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
