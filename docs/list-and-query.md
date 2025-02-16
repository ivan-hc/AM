## List and query all the applications available on the database
This section covers the procedures for consulting the lists of applications available in this database.

### List
Option `-l` or `list` shows the whole list of apps available.

This option uses `less` to show the list, so to exit its enough to press "**Q**".

```
am -l
```

To see only the AppImages from this list, use the `--appimages` flag
```
am -l --appimages
```

As you may have guessed, the lists are very long. However, you can use the `-q` or `query` option to search them. See below.

### Query
Option `-q` or `query` shows search results from the lists above.

https://github.com/user-attachments/assets/1b2f3f3b-fe22-416f-94d8-d5e0465b3f6d

```
am -q {KEYWORD}
am -q --appimages {KEYWORD}
am -q --pkg {PROGRAM1} {PROGRAM2}
```

If followed by `--appimages`, the search results will be only for the available AppImages from the "AM" database.

If followed by `--pkg`, all keywords will be listed also if not on the same line. This is good if you are looking for multiple packages among the ones available in the "AM" database.

------------------------------------------------------------------------

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |

------------------------------------------------------------------------
