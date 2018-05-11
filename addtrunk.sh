#/bin/sh
if [ -d "$1" ]; then
    echo "Package $1 already exists!"
    read -p "Do you want to update it (y/n)?" choice
    case $choice in
        y|Y) REINSTALL="yes";;
        n|N) echo "Goodbye!";exit 0;;
        *) echo "Invalid"; exit 1;;
    esac
fi

if [ $REINSTALL != "yes" ]; then
    mkdir "$1"
fi
wget -O "$1/PKGBUILD" "https://git.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/$1"
if [ ! -f "$1/PKGBUILD" ]; then
 echo "$1 not found."
 rm -rf "$1"
fi
VERSION=$(grep pkgver= $1/PKGBUILD | awk -F '=' '{print $2}')
REVISION=$(grep pkgrel= $1/PKGBUILD | awk -F '=' '{print $2}')
touch "$1""/v_""$VERSION""_""$REVISION"
