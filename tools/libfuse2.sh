#!/usr/bin/env bash

LIB=libfuse2

# CREATE THE FOLDER
mkdir /opt/$LIB
cd /opt/$LIB

# ADD THE REMOVER
echo '#!/bin/sh
rm -R -f /opt/'$LIB' /usr/local/lib/libfuse*' >> /opt/$LIB/remove
chmod a+x /opt/$LIB/remove

# DOWNLOAD THE ARCHIVE
mkdir tmp
cd ./tmp

LIBFUSE2_DEB=$(wget -q http://ftp.debian.org/debian/pool/main/f/fuse/ -O - | grep -Po '(?<=href=")[^"]*' | sort | grep -v exp | grep amd64 | grep "libfuse2_" | tail -1)
wget http://ftp.debian.org/debian/pool/main/f/fuse/"$LIBFUSE2_DEB"
ar x ./*.deb
tar fx ./data.tar.xz
cd ..
mkdir -p /usr/local/lib
mv ./tmp/lib/*/libfuse* /usr/local/lib/
rm -R -f ./tmp
ldconfig