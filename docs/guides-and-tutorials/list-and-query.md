## List and query all the applications available on the database
This section covers the procedures for consulting the lists of applications available in the database.

### List
Option `-l` or `list` shows the whole list of apps available in this repository. This option uses `less` to show the list, so to exit its enough to press "**Q**".

https://github.com/user-attachments/assets/eae9ea83-d1f7-4f15-8acf-0cfb7a75a1af

```
am -l
am -l --appimages
```
If the option `-l` is followed by `--appimages`, you will be able to see only the available AppImages.

### Query
Option `-q` or `query` shows search results from the list above.

https://github.com/user-attachments/assets/1b2f3f3b-fe22-416f-94d8-d5e0465b3f6d

```
am -q {KEYWORD}
am -q --appimages {KEYWORD}
am -q --pkg {PROGRAM1} {PROGRAM2}
```

If followed by `--appimages`, the search results will be only for the available AppImages.

If followed by `--pkg`, all keywords will be listed also if not on the same line. This is good if you are looking for multiple packages.

| [Back to "Guides and tutorials"](../../README.md#guides-and-tutorials) | [Back to "Main Index"](../../README.md#main-index) | ["Portable Linux Apps"](https://portable-linux-apps.github.io/) | [ "AppMan" ](https://github.com/ivan-hc/AppMan) |
| - | - | - | - |
