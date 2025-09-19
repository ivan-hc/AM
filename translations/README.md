# Welcome to the "translations" section of "AM"

Here you can download the files needed to translate or improve existing translations of your package manager for AppImages and portable apps.

-----------------------------

- [Glossary](#glossary)
- [How does "AM" translate into my language?](#how-does-am-translate-into-my-language)
- [Which file do I need to download to add a translation?](#which-file-do-i-need-to-download-to-add-a-translation)
- [Which file should I download to improve an existing translation?](#which-file-should-i-download-to-improve-an-existing-translation)
- [Which programs to use?](#which-programs-to-use)
- [How to test a language](#how-to-test-a-language)
- [Valid language codes](#valid-language-codes)
- [How to add a language](#how-to-add-a-language)

-----------------------------

## Glossary

Let's proceed in order, all translation files are based on [source.po](source.po), available in this place.

In this guide we will use often the following variables to explain the steps:
- `$county_code` is the identifier you find before the dot, in `echo "$LANG`, for example "it" for Italian or "sr" for Serbian (jump to the list "[Valid language codes](#valid-language-codes)")
- "`$DATADIR`" is your "`${XDG_DATA_HOME:-$HOME/.local/share}`", also known as just `~/.local/share` in almost all configurations

Keep these details in mind to better understand the next paragraphs.

-----------------------------

## How does "AM" translate into my language?

"AM" (version 9.8 or bigger) does this when you run an option at first start:
1. checks if a "`$DATADIR/AM/locale`" file exists

   a. if not empty, sets `$LANGUAGE` with the value inside it

   b. if empty or not available, checks your `$country_code`

2. if your `$country_code` is a [valid one](#valid-language-codes), then "AM" will check if a `$country_code.mo` file exists in [this directory](usr/share/locale) of this repository

   a. if your `$country_code` exists in here, it will be downloaded to your "`$DATADIR/locale`" directory, in a rootless way

   b. if your `$country_code` does not exists here, "AM" will set the "en" (English) value into a "`$DATADIR/AM/locale`" file

In case of "2b" (see above), it will be possible to add or use a different `$country_code` using the command
```
am translate $country_code
```
or
```
appman translate $country_code
```
if you use AppMan.

Again, see "[Valid language codes](#valid-language-codes)" for more information and check [this directory](usr/share/locale) to see the available ones.

**NOTE, Make sure you are connected to the internet, failure to download a .mo file could be due to this.**

-----------------------------

## Which file do I need to download to add a translation?

Download the [source.po](source.po) file.

-----------------------------

## Which file should I download to improve an existing translation?

Check your `$country_code` (see above) and download the `$country_code.po` file from the [translations/po-files](translations/po-files) directory of this repository.

-----------------------------

## Which programs to use?

You can use an offline editor like [Poedit](https://poedit.net/download), available in almost all distribution repositories (see https://pkgs.org/download/poedit), and there is also an unofficial AppImage, installable via AM/AppMan (`am -i poedit` or `appman -i poedit`).

Alternatively, use an online one: just search for "online .po editor" in your reference search engine and you will find several results, even free ones. These does not take up disk space and allows you to use your browser extensions, such as [this one](https://github.com/FilipePS/Traduzir-paginas-web) for Firefox-based browsers, to right-click and translate selected text.

Personally, I alternate between Poedit and online editors like [this one](https://localise.biz/free/poeditor), depending on my needs.

-----------------------------

## How to test a language

**Suppose we have a test.mo file for the language "jp" (Japanese):**

1. We set a value for `$DATADIR`, which is usually ~/.local/share, but may vary on other systems and configurations. To be sure not to make a mistake, execute the following command
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
mkdir -p "$DATADIR/AM" && echo "jp" > "$DATADIR/AM/locale"
```

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

## How to add a language

All you have to do is to put your `$country_code.po` file in the [po-files](po-files) directory of this repository.

The Github Actions workflow named "[Language Manager](../.github/workflows/language-updater.yml)" will do the rest, including creating the "am.mo" file for your language in less than one minute.

You will be able to use your country code by running `am translate $country_code` or `appman translate $country_code` in few minutes, depending on github.com times.

------------------------------------------------------------------------

| [Back to "Main Index"](../README.md#main-index) |
| - |

------------------------------------------------------------------------
