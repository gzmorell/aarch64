#/bin/sh
PACKAGE="$1"
DIRECTORY="aarch64-linux-gnu-$1"
if [ -d "$DIRECTORY" ]; then
    echo "Package $1 already exists!"
    read -p "Do you want to update it (y/n)?" choice
    case $choice in
        y|Y) REINSTALL="yes";;
        n|N) echo "Goodbye!";exit 0;;
        *) echo "Invalid"; exit 1;;
    esac
fi

if [ "$REINSTALL" != "yes" ]; then
    mkdir "$DIRECTORY"
fi
wget -O "$DIRECTORY/PKGBUILD" "https://git.archlinux.org/svntogit/packages.git/plain/trunk/PKGBUILD?h=packages/$PACKAGE"
RWGET=$?
if [ ! -f "$DIRECTORY/PKGBUILD" ] || [ $RWGET -ne 0 ]; then
 echo "$DIRECTORY not found."
 rm -rf "$DIRECTORY"
fi
VERSION=$(grep pkgver= $DIRECTORY/PKGBUILD | awk -F '=' '{print $2}')
REVISION=$(grep pkgrel= $DIRECTORY/PKGBUILD | awk -F '=' '{print $2}')
if [ "$VERSION " == " " ] || [ "$REVISION " == " " ]; then
 echo "Wrong version: $VERSION or revision: $REVISION."
 exit 1
fi
touch "$DIRECTORY""/v_""$VERSION""_""$REVISION"
