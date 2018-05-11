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

if [ "$REINSTALL" != "yes" ]; then
    mkdir "$1"
fi
wget -O "$1/PKGBUILD" "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=$1"
RWGET=$?
if [ ! -f "$1/PKGBUILD" ] || [ $RWGET -ne 0 ]; then
 echo "$1 not found."
 rm -rf "$1"
 exit 1
fi
VERSION=$(grep pkgver= $1/PKGBUILD | awk -F '=' '{print $2}')
REVISION=$(grep pkgrel= $1/PKGBUILD | awk -F '=' '{print $2}')
if [ "$VERSION " == " " ] || [ "$REVISION " == " " ]; then
 echo "Wrong version: $VERSION or revision: $REVISION."
 exit 1
fi
touch "$1""/v_""$VERSION""_""$REVISION"
