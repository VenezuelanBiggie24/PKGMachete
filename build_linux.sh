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
# To create an AppImage in the future, you would do something like this:
APPDIR="$OUTPUT_DIR/PkgMerge.AppDir"
mkdir -p "$APPDIR/usr/bin"
cp pkg-merge "$APPDIR/usr/bin/"

# Create a simple .desktop file
cat << 'EOF' > "$APPDIR/pkg-merge.desktop"
[Desktop Entry]
Name=PkgMerge
Exec=pkg-merge
Icon=pkg-merge
Type=Application
Categories=Utility;
EOF

# Ensure there's an icon (using the existing one)
# cp ../icon.jpg "$APPDIR/pkg-merge.png" 

# Note: AppImage creation requires linuxdeploy / appimagetool, which are not included here.
# To finish AppImage creation you would run:
# appimagetool "$APPDIR"

echo "Standalone Linux binary prepared."
