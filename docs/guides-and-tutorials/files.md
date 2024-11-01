### List the installed applications
Option `-f` or `files`, it shows the installed apps, the version, the size and the type of application:

https://github.com/user-attachments/assets/31e36845-48e9-4274-8978-ca86b525d797

By default apps are sorted by size, use "`--byname`" to sort by name. With the option "`--less`" it shows only the number of installed apps.
```
am -f
am -f --byname
am -f --less
```
or
```
appman -f
appman -f --byname
appman -f --less
```

------------------------------------------------------------------------