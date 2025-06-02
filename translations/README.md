# Welcome to the "translations" section of "AM"

Here you can download the files needed to translate or improve existing translations of your package manager for AppImages and portable apps.

-----------------------------

- [Files to download](#files-to-download)
- [Which programs to use](#which-programs-to-use)
- [How to test a language](#how-to-test-a-language)
- [Valid language codes](#valid-language-codes)
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

## How to test a language
Suppose we have a test.mo file for the language "jp" (Japanese):

1. We set a value for DATADIR, which is usually ~/.local/share, but may vary on other systems and configurations. To be sure not to make a mistake, execute the following command
```
export DATADIR="${XDG_DATA_HOME:-$HOME/.local/share}"
```

2. Let's create a path for the language to use, use this command
```
mkdir -p "$DATADIR/locale/jp/LC_MESSAGES"
```

3. Let's put the test.mo file in the directory created in step two, and rename it to am.mo
```
cp -r test.mo "$DATADIR"/locale/jp/LC_MESSAGES/am.mo
```
if you want to test it in AppMan, you can create a link to the am.mo file
```
ln -sf "$DATADIR/locale/jp/LC_MESSAGES/am.mo" "$DATADIR/locale/jp/LC_MESSAGES/appman.mo"
```

4. Set AM's language to "jp" manually
```
echo "jp" > "$DATADIR/AM/locale"
```
Here I assume that the directory $DATADIR/AM" exists, as it is automatically created when you first start AM or AppMan

5. Use AM/AppMan to test the changes.

-----------------------------

## Valid language codes
By default, AM checks a list of over 200 valid language codes. Here they are:
```
ab ace ach af ain ak am am_ET an ang ar as as_IN ast ay az az_AZ az_IR
ba bal bar be be@latin ber be@tarask bg bi bn bn_BD bn_IN bo br brx bs byn
ca ca@valencia ce cgg ch chr ckb cmn co crh cs csb cs_CZ cv cy
da de de_CH de_DE de@hebrew dv dz
ee el en en@arabic en_AU en@boldquot en_CA en@cyrillic en_GB en@greek en@hebrew en_NZ en@piglatin en@quot en@shaw en_US eo es es_AR es_CO es_ES es_EU es_MX et eu
fa fa_IR ff fi fil fo fr fr_CA fr_FR frp fur fy
ga gd gez gl gn gu gv
ha haw he hi hne hr hsb ht hu hu_HU hy hy_AM hye hye_RU
ia id id_ID ie ig io is it iu
ja jam
ka kab kg ki kk kl km kmr kn ko kok ks ks_IN ku ku_IQ kv kw kw_GB ky
la lb lg li lo locale.alias lt ltg lv
mai mg mhr mi mjw mk ml mn mo mr ms mt my
na nah nan nap nb nb_NO nds ne nl nl_BE nl_NL nn no nso nv
oc om or or_IN
pa pap pa_PK pi pl pms ps pt pt_BR pt_PT
qu quz
ro rom ro_MD ru rue ru_UA rw
sa sat sc sd se shn si sk sl sm sma sn so son sq sr sr@ije sr@ijekavian sr@ijekavianlatin sr@latin sr@Latn sr_RS sr_RS@latin sv sw szl
ta ta_LK te tet tg th ti tig tk tl tr tt tt@iqtelif tzm
ug uk ur ur_PK uz uz@cyrillic uz@Latn
ve vec vi
wa wae wal wo
xh
yi yo
zgh zh_CN zh_Hans zh_Hant zh_HK zh_SG zh_TW zu
```
Setting an invalid value will set AM/AppMan to "en", i.e. English (standard).

-----------------------------

## How to add or edit an existing language

Just upload the .po file to the "translations" directory. Nothing else.

The automatic workflow in Github Actions will do the rest.

------------------------------------------------------------------------

| [Back to "Main Index"](../../README.md#main-index) |
| - |

------------------------------------------------------------------------
