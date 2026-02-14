#!/bin/sh
# Author: https://github.com/Azathothas
# First draft: February 25, 2025, on Discord https://discord.com/channels/1313385177703256064/1313385178361499732/1341733386464657461
# Description: A simple script to download artifacts from the Soarpkg's OCI registry using "wget" and "curl"

#Input
if [ $# -ne 2 ]; then
	echo "Usage: $0 <ghcr-blob> <output-file-or-path>" >&2
	exit 1
else
	input="$1" #ghcr_blob as input
	file="$2" #name or path for output
fi

#Error if input doesn't contain ghcr.io [Sanity Check]
if ! echo "$input" | grep -q "ghcr.io"; then
	echo "Error: Input must contain ghcr.io" >&2
	exit 1
fi
	
#Process the URL
processed_url=$(echo "$input" | \
	#Remove http:// or https:// if present [IMPORTANT]
	sed 's|^[[:space:]]*https\?://||' | \
	#Remove quotes and whitespace [IMPORTANT]
	tr -d "'\"\040\011\012\015" | \
	#Remove leading and trailing slashes [IMPORTANT]
	sed 's|^/||; s|/$||')

#Split and transform the URL parts [IMPORTANT]
first_part=$(echo "$processed_url" | cut -d@ -f1)
second_part=$(echo "$processed_url" | cut -d@ -f2)

#Add v2 after ghcr.io [IMPORTANT]
transformed_first_part=$(echo "$first_part" | sed 's|ghcr.io|ghcr.io/v2|')

#Replace @ with /blobs/ in the second part [IMPORTANT]
transformed_second_part=$(echo "$second_part" | sed 's|^|/blobs/|')

#Combine the parts with https:// prefix and ensure clean whitespace [IMPORTANT]
final_url=$(echo "https://$transformed_first_part$transformed_second_part" | sed 's/[[:space:]]*//g')

#Make the HTTP request with some parameters [IMPORTANT]
headers=$(curl --globoff --location --head -qfsS -X 'GET' \
	--retry 3 --header "Authorization: Bearer QQ==" \
	"$final_url")

#Extract redirect URL with robust whitespace handling [IMPORTANT]
redirect_url=$(echo "$headers" | grep "^[[:space:]]*[Ll]ocation:[[:space:]]*" | sed 's/^[[:space:]]*[Ll]ocation:[[:space:]]*//')

#Final req
if [ -n "$redirect_url" ]; then
	#Clean any whitespace from redirect_url
	redirect_url=$(echo "$redirect_url" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
	#Download it with wget 
	if wget --version | head -1 | grep -q ' 1.'; then
		wget -q --no-verbose --show-progress --progress=bar "$redirect_url" -O "$file"
	else
		wget "$redirect_url" -O "$file"
	fi
else
	echo "Error: Failed to Get Redirect URL (Maybe ghcr_blob is invalid?)" >&2
fi