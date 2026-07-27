#!/bin/bash
set -e

APP_NAME="PKGMachete"
BUNDLE_ID="com.venezuenbiggie24.pkgmachete"
APP_DIR="${APP_NAME}.app"
DMG_NAME="${APP_NAME}-V5.dmg"
ICON_PATH="pkg_merge_icon.jpg"

echo "Cleaning up old builds..."
rm -rf "$APP_DIR" "$DMG_NAME" pkgmachete-cli PkgMerge DMG_Staging

echo "1. Compiling C++ CLI Backend..."
clang++ -std=c++20 -O3 pkgmerge.cpp -o pkgmachete-cli

echo "2. Compiling SwiftUI Frontend..."
swiftc -module-cache-path ./.swift_cache -parse-as-library app.swift -o "$APP_NAME"

echo "3. Creating App Bundle Structure..."
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

echo "4. Moving binaries into bundle..."
mv "$APP_NAME" "$APP_DIR/Contents/MacOS/"
mv pkgmachete-cli "$APP_DIR/Contents/Resources/"

echo "5. Creating Info.plist..."
cat > "$APP_DIR/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>${BUNDLE_ID}</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
</dict>
</plist>
EOF

echo "6. Processing Icon..."
if [ -f "$ICON_PATH" ]; then
    mkdir -p MyIcon.iconset
    sips -s format png -z 16 16     "$ICON_PATH" --out MyIcon.iconset/icon_16x16.png > /dev/null
    sips -s format png -z 32 32     "$ICON_PATH" --out MyIcon.iconset/icon_16x16@2x.png > /dev/null
    sips -s format png -z 32 32     "$ICON_PATH" --out MyIcon.iconset/icon_32x32.png > /dev/null
    sips -s format png -z 64 64     "$ICON_PATH" --out MyIcon.iconset/icon_32x32@2x.png > /dev/null
    sips -s format png -z 128 128   "$ICON_PATH" --out MyIcon.iconset/icon_128x128.png > /dev/null
    sips -s format png -z 256 256   "$ICON_PATH" --out MyIcon.iconset/icon_128x128@2x.png > /dev/null
    sips -s format png -z 256 256   "$ICON_PATH" --out MyIcon.iconset/icon_256x256.png > /dev/null
    sips -s format png -z 512 512   "$ICON_PATH" --out MyIcon.iconset/icon_256x256@2x.png > /dev/null
    sips -s format png -z 512 512   "$ICON_PATH" --out MyIcon.iconset/icon_512x512.png > /dev/null
    sips -s format png -z 1024 1024 "$ICON_PATH" --out MyIcon.iconset/icon_512x512@2x.png > /dev/null
    iconutil -c icns MyIcon.iconset -o "$APP_DIR/Contents/Resources/AppIcon.icns"
    rm -rf MyIcon.iconset
fi

echo "7. Ad-Hoc Signing (Bypass Apple Developer requirement)..."
find "$APP_DIR" -name ".DS_Store" -delete
dot_clean -v "$APP_DIR"
xattr -cr "$APP_DIR"
xattr -cr "$APP_DIR"
codesign -s - --deep --force "$APP_DIR"

echo "8. Creating DMG Staging Directory..."
mkdir -p DMG_Staging
cp -R "$APP_DIR" DMG_Staging/
ln -s /Applications DMG_Staging/Applications

echo "9. Creating Installation and Gatekeeper Bypass Script..."
cat > "DMG_Staging/Install_and_Open_${APP_NAME}.command" <<EOF
#!/bin/bash
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
echo "Requesting administrator privileges to install ${APP_NAME}... / Solicitando permisos de administrador para instalar ${APP_NAME}..."
osascript -e 'do shell script "cp -R \"'"\$DIR"'/${APP_NAME}.app\" \"/Applications/\" && xattr -cr \"/Applications/${APP_NAME}.app\"" with administrator privileges'
echo "Opening the application... / Abriendo la aplicación..."
open "/Applications/${APP_NAME}.app"
echo "Done! You can now close this terminal window. / ¡Listo! Ya puedes cerrar esta ventana de la terminal."
sleep 3
EOF
chmod +x "DMG_Staging/Install_and_Open_${APP_NAME}.command"

echo "10. Building final DMG..."
hdiutil create -volname "${APP_NAME}" -srcfolder DMG_Staging -ov -format UDZO "${DMG_NAME}"
rm -rf DMG_Staging

echo "Done! Generated ${DMG_NAME}"
