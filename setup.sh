#!/bin/sh

VOID_MKLIVE='https://github.com/void-linux/void-mklive/archive/master.tar.gz'
VOID_PACKAGES='https://github.com/void-linux/void-packages/archive/master.tar.gz'

mkdir -pv setup
cd setup
curl -LO $VOID_MKLIVE
tar -xvf master.tar.gz && rm master.tar.gz
cd void-mklive-master && make && cd ..
curl -LO $VOID_PACKAGES
tar -xvf master.tar.gz && rm master.tar.gz
cd void-packages-master
./xbps-src binary-bootstrap
./xbps-src -j6 pkg dialog
./xbps-src -j6 pkg xorg
./xbps-src -j6 pkg dmenu
./xbps-src -j6 pkg dwm
./xbps-src -j6 pkg void-installer
cd ..
mkdir -p dir/home/rb/
touch dir/home/rb/test
cd void-mklive-master
sudo ./mklive.sh -a x86_64-musl -r ../void-packages-master/hostdir/binpkgs -I ../dir -T bytomski-void
