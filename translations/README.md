# Welcome to the "translations" section of "AM"

Here you can download the files needed to translate or improve existing translations of your package manager for AppImages and portable apps.

-----------------------------

- [Files to download](#files-to-download)
- [Which programs to use](#which-programs-to-use)
- [How to add or edit an existing language](#how-to-add-or-edit-an-existing-language)

-----------------------------

Let's proceed in order, the translation files available here are all based on source.po

To add files in this section, you must follow the following steps:
- files with the .po extension go in the root of this directory
- files with the .mo extension (those used by AM) must be inserted in the directory usr/share/locale/"$country_code"/LC_MESSAGES (where "$country_code" is the identifier you find before the dot, in `echo "$LANG`, for example "it" for Italian or "sr" for Serbian) of this repository

"AM" from version 9.8 downloads the localization file suitable for your system in the local directory ~/.local/share/locale.

If this .mo file is not available in this directory, "AM" will be set in English by default. However, it will be possible to add or use a different code using the command
```
am translate $country_code
```
or
```
appman translate $country_code
```
if you use AppMan.

Now, let's see what files you need to work on translations, and what software to use.

-----------------------------

## Files to download

#### *To start a new translation...*
...download the [source.po](source.po) file

#### *To synchronize an existing translation...*
...download the [source.pot](source.pot) file

#### *To improve an existing translation...*
...download any other .po file from this directory

-----------------------------

## Which programs to use

You can use an offline editor like [Poedit](https://poedit.net/download), available in almost all distribution repositories (see https://pkgs.org/download/poedit), or use an online one, just search for "online .po editor" in your reference search engine and you will find several results, even free ones.

#### *Advantages of an offline editor*
- You can use it locally and without an internet connection.

#### *Advantages of an online editor*
- Does not take up disk space
- Allows you to use your browser extensions, such as this one, to right-click and translate selected text

Personally, I alternate between the two.

-----------------------------

## How to add or edit an existing language

Just upload the .po file to the "translations" directory. Nothing else.

The automatic workflow in Github Actions will do the rest.

------------------------------------------------------------------------

| [Back to "Main Index"](../../README.md#main-index) |
| - |

------------------------------------------------------------------------
