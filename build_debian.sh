#!/usr/bin/env bash
set -e

VERSION="3.1.0"
ARCH="amd64"
PKG_NAME="PKGMachete_${VERSION}_${ARCH}"

echo "Building C++ engine..."
# Compile the C++ code
mkdir -p build_linux
cd build_linux
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu)
cd ..

echo "Creating Debian package structure..."
mkdir -p "$PKG_NAME/DEBIAN"
mkdir -p "$PKG_NAME/opt/PKGMachete/bin"
mkdir -p "$PKG_NAME/opt/PKGMachete/gui"
mkdir -p "$PKG_NAME/usr/share/applications"
mkdir -p "$PKG_NAME/usr/share/pixmaps"

# Copy binary
cp build_linux/pkg-merge "$PKG_NAME/opt/PKGMachete/bin/"
chmod 755 "$PKG_NAME/opt/PKGMachete/bin/pkg-merge"

# Copy Python GUI
cp linux_app/main.py "$PKG_NAME/opt/PKGMachete/gui/"
chmod 755 "$PKG_NAME/opt/PKGMachete/gui/main.py"

# Copy icon
if [ -f "pkg_merge_icon.jpg" ]; then
    cp pkg_merge_icon.jpg "$PKG_NAME/usr/share/pixmaps/pkgmachete.jpg"
elif [ -f "icon.jpg" ]; then
    cp icon.jpg "$PKG_NAME/usr/share/pixmaps/pkgmachete.jpg"
fi
[ -f "$PKG_NAME/usr/share/pixmaps/pkgmachete.jpg" ] && chmod 644 "$PKG_NAME/usr/share/pixmaps/pkgmachete.jpg"

# Create DEBIAN/control
cat << EOF > "$PKG_NAME/DEBIAN/control"
Package: pkgmachete
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Depends: python3, python3-tk
Maintainer: Developer <dev@example.com>
Description: PKGMachete
 Merge split PS4/PS5 PKG files easily with a modern GUI.
 .
 NOTE: You must install the 'customtkinter' python package manually.
 Run: pip3 install customtkinter
EOF

# Create postinst script to instruct user about customtkinter
cat << 'EOF' > "$PKG_NAME/DEBIAN/postinst"
#!/bin/sh
set -e

echo ""
echo "================================================================"
echo " PKGMachete has been installed!"
echo " To run the GUI, you MUST install customtkinter via pip:"
echo "    pip3 install customtkinter"
echo "================================================================"
echo ""

exit 0
EOF
chmod 755 "$PKG_NAME/DEBIAN/postinst"

# Create .desktop file
cat << EOF > "$PKG_NAME/usr/share/applications/pkgmachete.desktop"
[Desktop Entry]
Name=PKGMachete
Exec=python3 /opt/PKGMachete/gui/main.py
Icon=/usr/share/pixmaps/pkgmachete.jpg
Terminal=false
Type=Application
Categories=Utility;
EOF
chmod 644 "$PKG_NAME/usr/share/applications/pkgmachete.desktop"

echo "Setting directory permissions..."
find "$PKG_NAME" -type d -exec chmod 755 {} \;

echo "Building Debian package..."
dpkg-deb --build "$PKG_NAME"

echo "Package $PKG_NAME.deb created successfully!"
