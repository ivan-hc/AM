#!/usr/bin/env bash

# extract strings for AM translation
# Using gum and bat or not
# Author: zenobit

list="INSTALL AM-INSTALLER APP-MANAGER modules/database.am modules/install.am modules/management.am modules/sandboxes.am modules/template.am"

gumS() {
  if command -v gum -v >>/dev/null; then
    gum style --border double --border-foreground 2 --padding "0 3" "$@"
  else
    echo -e "\n$@\n"
  fi
}

gumW() {
  if command -v gum -v >>/dev/null; then
    gum style --border double --padding "0 3" "$@"
  else
    echo -e "\n$@\n"
  fi
}

gumQ() {
  if command -v gum -v >>/dev/null; then
    gum confirm --selected.background 2 --prompt.foreground 2 "$@"
  else
    echo -e "\n$@\n"
    read -p "Press n for exit, anything else for continue..." yn
    if echo "$yn" | grep -i '^n' >/dev/null 2>&1; then
      exit 1
    fi
  fi
}

if [ -f po/am.pot ]; then
  #gumQ "Remove existing file?" || exit 1
  rm po/am.pot && gumW "am.pot removed"
fi

gumS "Creating directories"
mkdir -p po

gumS "Extracting strings..."
for file in ${list}; do
  gumW "$file"
  bash --dump-po-strings "$file" >> po/am.pot
  gumS "Extraction completed"
  #gumQ "Show am.pot? (needs bat)" && bat po/am.pot
  gumS "Fixing strings..."
  gumW '\\\' && sed -i ':a;N;$!ba;s/\\\\\\/\\\\/g' po/am.pot
  gumW '\\' && sed -i ':a;N;$!ba;s/\\\\/\\/g' po/am.pot
  gumW '\n"
"\n"
"' && sed -i ':a;N;$!ba;s/\\n"\n"\\n"\n"/\n\n/g' po/am.pot
  gumW '"
"\n"
"' && sed -i ':a;N;$!ba;s/"\n"\\n"\n"/\n\n/g' po/am.pot
  gumW '\n"
"' && sed -i ':a;N;$!ba;s/\\n"\n"/\n/g' po/am.pot
  gumW '"
"' && sed -i ':a;N;$!ba;s/""\n"/"\n/g' po/am.pot
  gumS "Fixing completed"
done

gumS "am.pot ready for translation"
#gumS "Creating en_US.pot"
#cp po/am.pot po/en_US.pot

#  FILE_PATH="po/am.pot"
#  TEMP_FILE=$(mktemp)
#  msgid_content=""
#  while read -r line; do
#    if [[ "$line" =~ ^msgid ]]; then
#      msgid_content=$(echo "$line" | sed 's/msgid //')
#      while read -r next_line; do
#        if [[ "$next_line" =~ ^msgid || "$next_line" =~ ^msgstr ]]; then
#          break
#        fi
#        msgid_content+=$'\n'"$next_line"
#      done
#      echo "msgid $msgid_content" >> "$TEMP_FILE"
#      msgid_content="$msgid_content"
#      export msgid_content
#    elif [[ "$line" =~ ^msgstr ]]; then
#      echo "msgstr $msgid_content" >> "$TEMP_FILE"
#    else
#      echo "$line" >> "$TEMP_FILE"
#    fi
#  done < "$FILE_PATH"
# mv "$TEMP_FILE" "$FILE_PATH"
# bat "$TEMP_FILE"
# echo "You can now use en_US.pot for translation"

# To add new language, add language code to LINGUAS file
echo 'cs' > po/LINGUAS
echo 'it' >> po/LINGUAS
mapfile -t linguas <po/LINGUAS && \
 for i in "${linguas[@]}"; do
   mkdir -p usr/share/locale/"${i}"/LC_MESSAGES/ && \
   msgfmt -o usr/share/locale/"${i}"/LC_MESSAGES/am.mo po/"${i}".po
 done

gumQ "Copy files to /usr/share/? (sudo needed)" && sudo cp -r usr/share/locale /usr/share/
