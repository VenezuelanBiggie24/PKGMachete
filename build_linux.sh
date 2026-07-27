#!/usr/bin/env bash
set -e

echo "Building pkg-merge for Linux..."
VERSION="3.1.0"

# Create a build directory
BUILD_DIR="build_linux"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Run CMake and compile
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu)

# Prepare universal tar.gz package
echo "Creating universal Linux package..."
PACKAGE_NAME="PKGMachete_${VERSION}_Linux_Universal"
mkdir -p "$PACKAGE_NAME"

# Copy files into package directory
cp pkg-merge "$PACKAGE_NAME/"
cp ../linux_app/main.py "$PACKAGE_NAME/"
cp ../install.sh "$PACKAGE_NAME/"
chmod +x "$PACKAGE_NAME/install.sh"
chmod +x "$PACKAGE_NAME/pkg-merge"
chmod +x "$PACKAGE_NAME/main.py"

if [ -f "../pkgmachete_icon.jpg" ]; then
    cp ../pkgmachete_icon.jpg "$PACKAGE_NAME/pkgmachete.jpg"
elif [ -f "../icon.jpg" ]; then
    cp ../icon.jpg "$PACKAGE_NAME/pkgmachete.jpg"
fi

# Create tar.gz archive
tar -czvf "${PACKAGE_NAME}.tar.gz" "$PACKAGE_NAME"
mv "${PACKAGE_NAME}.tar.gz" ../

echo "Build successful! Universal package is located in the project root: ${PACKAGE_NAME}.tar.gz"

