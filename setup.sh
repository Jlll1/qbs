#!/bin/sh

TARGET_ARCH=x86_64

VOID_MKLIVE="https://github.com/void-linux/void-mklive/archive/master.tar.gz"
VOID_PACKAGES="https://github.com/void-linux/void-packages/archive/master.tar.gz"
DOTFILES="https://github.com/Jlll1/dotfiles/archive/master.tar.gz"

BASE_PKGS="dialog cryptsetup lvm2 mdadm void-docs-browse grub-x86_64-efi"
ESSENTIAL_PKGS="pulseaudio pavucontrol xorg alacritty"
MEDIA_PKGS="qutebrowser mpv"
DEV_PKGS="make git neovim nodejs vscode go gcc"
MISC_PKGS="curl"
SRC_PKGS="dmenu dwm"
PACKAGES="$BASE_PKGS $ESSENTIAL_PKGS $MEDIA_PKGS $DEV_PKGS $MISC_PKGS $SRC_PKGS"


# main()

mkdir setup
cd setup

curl -LO $VOID_MKLIVE
tar -xvf master.tar.gz && rm master.tar.gz
cd void-mklive-master && make && cd ..

curl -LO $VOID_PACKAGES
tar -xvf master.tar.gz && rm master.tar.gz

curl -LO $DOTFILES
tar -xvf master.tar.gz && rm master.tar.gz

cp -rf dotfiles-master/void-packages/* void-packages-master/srcpkgs/
rm -rf dotfiles-master/void-packages/

mkdir -p dir/home/rb
cp -rf dotfiles-master/.[^.]* dir/home/rb/
rm -rf dotfiles-master

cd void-packages-master
./xbps-src binary-bootstrap
for PKG in $SRC_PKGS
do
  ./xbps-src -j8 -a $TARGET_ARCH pkg $PKG
done
cd ..

cd void-mklive-master
sudo ./mklive.sh -a $TARGET_ARCH -r ../void-packages-master/hostdir/binpkgs -p "$PACKAGES" -I ../dir
mv *.iso ../../ && cd ../..
sudo rm -rf setup
