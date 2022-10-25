#!/bin/sh
wget --no-check-certificate https://github.com/choishingwan/PRSice/releases/download/2.3.5/PRSice_linux.zip  && \
    unzip PRSice_linux.zip  && \
    rm -rf PRSice_linux.zip

cp PRSice_linux /bin/.
ln -s /usr/bin/PRSice_linux /usr/bin/PRSice
