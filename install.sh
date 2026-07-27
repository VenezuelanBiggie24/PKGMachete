#!/usr/bin/env bash
set -e

echo "==================================================="
echo "       PKGMachete Universal Linux Installer        "
echo "==================================================="
echo ""

if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script with sudo or as root."
  echo "Example: sudo ./install.sh"
  exit 1
fi

INSTALL_DIR="/opt/PKGMachete"
BIN_DIR="$INSTALL_DIR/bin"
GUI_DIR="$INSTALL_DIR/gui"

echo "➡️  Creating installation directories..."
mkdir -p "$BIN_DIR"
mkdir -p "$GUI_DIR"
mkdir -p "/usr/share/applications"
mkdir -p "/usr/share/pixmaps"

echo "➡️  Copying files..."
if [ ! -f "pkg-merge" ] || [ ! -f "main.py" ]; then
    echo "❌ Error: Installation files not found. Are you running this script from the extracted folder?"
    exit 1
fi

cp pkg-merge "$BIN_DIR/"
chmod +x "$BIN_DIR/pkg-merge"

cp main.py "$GUI_DIR/"
chmod +x "$GUI_DIR/main.py"

if [ -f "pkgmachete.jpg" ]; then
    cp pkgmachete.jpg "/usr/share/pixmaps/pkgmachete.jpg"
    chmod 644 "/usr/share/pixmaps/pkgmachete.jpg"
fi

echo "➡️  Creating desktop shortcut..."
cat << EOF > "/usr/share/applications/pkgmachete.desktop"
[Desktop Entry]
Name=PKGMachete
Exec=python3 /opt/PKGMachete/gui/main.py
Icon=/usr/share/pixmaps/pkgmachete.jpg
Terminal=false
Type=Application
Categories=Utility;
EOF
chmod 644 "/usr/share/applications/pkgmachete.desktop"

echo "➡️  Checking dependencies..."
if command -v pip3 &> /dev/null; then
    echo "Installing customtkinter via pip..."
    # Ensure it's installed globally or for the user
    pip3 install customtkinter --break-system-packages 2>/dev/null || pip3 install customtkinter
else
    echo "⚠️  WARNING: pip3 not found. You must install 'customtkinter' manually to use the GUI."
    echo "Run: sudo apt install python3-pip && pip3 install customtkinter"
fi

echo ""
echo "✅ PKGMachete has been successfully installed!"
echo "You can now launch it from your application menu."
echo "==================================================="
