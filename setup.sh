#!/bin/sh

VOID_MKLIVE="https://github.com/void-linux/void-mklive/archive/master.tar.gz"
VOID_PACKAGES="https://github.com/void-linux/void-packages/archive/master.tar.gz"
#DOTFILES="https://github.com/Jlll1/dotfiles/archive/master.tar.gz"

BASE_PKGS="dialog cryptsetup lvm2 mdadm void-docs-browse grub-x86_64-efi"
SRC_PKGS="dmenu dwm"
PACKAGES="$BASE_PKGS $SRC_PKGS xorg alacritty git make curl qutebrowser"


# main()

mkdir setup
cd setup

curl -LO $VOID_MKLIVE
tar -xvf master.tar.gz && rm master.tar.gz
cd void-mklive-master && make && cd ..

curl -LO $VOID_PACKAGES
tar -xvf master.tar.gz && rm master.tar.gz

#curl -LO $DOTFILES
#tar -xvf master.tar.gz && rm master.tar.gz

#cp -rf dotfiles-master/void-packages/* void-packages-master/srcpkgs/
#rm -rf dotfiles-master/void-packages/

#mkdir -p /dir/home/rb
#cp -rf dotfiles-master/.[^.]* /dir/home/rb/
#rm -rf dotfiles-master

cd void-packages-master
./xbps-src binary-bootstrap
for PKG in $PACKAGES
do
  ./xbps-src -j8 pkg $PKG
done
cd ..

cd void-mklive-master
sudo ./mklive.sh -a x86_64-musl -r ../void-packages-master/hostdir/binpkgs -p "$PACKAGES"
mv *.iso ../../ && cd ../..
sudo rm -rf setup
