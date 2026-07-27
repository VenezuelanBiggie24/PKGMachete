#!/usr/bin/env bash
set -e

echo "Building pkg-merge for Linux..."

# Create a build directory
BUILD_DIR="build_linux"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Run CMake and compile
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu)

# Prepare output directory
OUTPUT_DIR="../linux_dist"
mkdir -p "$OUTPUT_DIR"

# Copy the compiled binary
cp pkg-merge "$OUTPUT_DIR/"

echo "Build successful! Binary is located in $OUTPUT_DIR/pkg-merge"

# (Optional) AppImage preparation skeleton
# To create an AppImage in the future, you would bundle the Python GUI and binary:
APPDIR="$OUTPUT_DIR/PkgMerge.AppDir"
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/opt/PKGMachete/gui"
mkdir -p "$APPDIR/opt/PKGMachete/bin"

# Copy C++ binary
cp pkg-merge "$APPDIR/opt/PKGMachete/bin/"

# Copy Python GUI
cp ../linux_app/main.py "$APPDIR/opt/PKGMachete/gui/"

# Create an AppRun script or .desktop file to launch the Python GUI
cat << 'EOF' > "$APPDIR/pkgmachete.desktop"
[Desktop Entry]
Name=PKGMachete
Exec=python3 /opt/PKGMachete/gui/main.py
Icon=pkgmachete
Type=Application
Categories=Utility;
EOF

# Ensure there's an icon
cp ../icon.jpg "$APPDIR/pkgmachete.png" || true

# Note: AppImage creation requires linuxdeploy / appimagetool, as well as a bundled python runtime or appimage-builder.
# For standard linux distribution, please see build_debian.sh which focuses on the .deb package.
# To finish AppImage creation using appimagetool, you would run:
# appimagetool "$APPDIR"

echo "Standalone Linux binary and AppImage skeleton prepared. (See build_debian.sh for .deb packaging)"
