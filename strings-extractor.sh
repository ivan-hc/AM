#!/usr/bin/env bash

AMVERSION=$(am -v)

mkdir -p translations

cat <<-HEREDOC >> translations/source.pot
# File with translation for AM
# FIRST AUTHOR <EMAIL@ADDRESS>, $(date +"%Y")
msgid ""
msgstr ""
"Project-Id-Version: AM ${AMVERSION}\n"
"Report-Msgid-Bugs-To: https://github.com/ivan-hc/AM\n"
"POT-Creation-Date: $(date +"%Y-%m-%d")\n"
"PO-Revision-Date: $(date +"%Y-%m-%d")\n"
"Last-Translator: ${TRANSLATOR_NAME} <${TRANSLATOR_EMAIL}>\n"
"Language-Team: ${LANGUAGE} <LL@li.org>\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
"Plural-Forms: nplurals=INTEGER; plural=EXPRESSION;\n"
HEREDOC

items="APP-MANAGER modules/database.am modules/install.am modules/management.am modules/sandboxes.am modules/template.am"
if [ ! -f ./APP-MANAGER ]; then
	for item in $items; do
		bash --dump-po-strings "/opt/am/$item" >> translations/source.pot
	done
else
	for item in $items; do
		bash --dump-po-strings "$item" >> translations/source.pot
	done
fi

AMVERSION=$(am -v)

msguniq translations/source.pot -o translations/source.po

msgcat --output-file=translations/source.pot --unique --indent --no-wrap translations/source.po