#!/bin/sh
export VERSION='2.00a3.6'
wget --no-check-certificate "https://github.com/chrchang/plink-ng/archive/refs/tags/v$VERSION.tar.gz"
tar -xzf "v$VERSION.tar.gz"
cd plink-ng-$VERSION/2.0/build_dynamic
make -j 4
mv plink2 /usr/bin/ 
cd -
rm -rf *