

#!/bin/bash

# Icon Generator for BlockStarDesk
# Requires: ImageMagick (install with: brew install imagemagick)

MASTER_ICON="blockstardesk-icon.png"

if [ ! -f "$MASTER_ICON" ]; then
    echo "❌ Error: $MASTER_ICON not found!"
    echo "Please create a 1024x1024 PNG icon first."
    exit 1
fi

echo "🎨 Generating icons from $MASTER_ICON..."
echo ""

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null && ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick not installed!"
    echo "Install with: brew install imagemagick"
    exit 1
fi

# Use 'magick' or 'convert' depending on ImageMagick version
CMD="convert"
if command -v magick &> /dev/null; then
    CMD="magick"
fi

# Create output directory
mkdir -p icons_output

# macOS Icons
echo "📱 Generating macOS icons..."
mkdir -p icons_output/macos
for size in 16 32 64 128 256 512 1024; do
    $CMD "$MASTER_ICON" -resize ${size}x${size} "icons_output/macos/app_icon_${size}.png"
    echo "  ✓ ${size}x${size}"
done

# Windows Icon (requires ImageMagick)
echo "🪟 Generating Windows icon..."
mkdir -p icons_output/windows
$CMD "$MASTER_ICON" \
    \( -clone 0 -resize 16x16 \) \
    \( -clone 0 -resize 32x32 \) \
    \( -clone 0 -resize 48x48 \) \
    \( -clone 0 -resize 64x64 \) \
    \( -clone 0 -resize 128x128 \) \
    \( -clone 0 -resize 256x256 \) \
    -delete 0 "icons_output/windows/app_icon.ico"
echo "  ✓ app_icon.ico"

# iOS Icons
echo "📱 Generating iOS icons..."
mkdir -p icons_output/ios
# iPhone
$CMD "$MASTER_ICON" -resize 40x40   "icons_output/ios/Icon-App-20x20@2x.png"
$CMD "$MASTER_ICON" -resize 60x60   "icons_output/ios/Icon-App-20x20@3x.png"
$CMD "$MASTER_ICON" -resize 29x29   "icons_output/ios/Icon-App-29x29@1x.png"
$CMD "$MASTER_ICON" -resize 58x58   "icons_output/ios/Icon-App-29x29@2x.png"
$CMD "$MASTER_ICON" -resize 87x87   "icons_output/ios/Icon-App-29x29@3x.png"
$CMD "$MASTER_ICON" -resize 80x80   "icons_output/ios/Icon-App-40x40@2x.png"
$CMD "$MASTER_ICON" -resize 120x120 "icons_output/ios/Icon-App-40x40@3x.png"
$CMD "$MASTER_ICON" -resize 120x120 "icons_output/ios/Icon-App-60x60@2x.png"
$CMD "$MASTER_ICON" -resize 180x180 "icons_output/ios/Icon-App-60x60@3x.png"
# iPad
$CMD "$MASTER_ICON" -resize 20x20   "icons_output/ios/Icon-App-20x20@1x.png"
$CMD "$MASTER_ICON" -resize 40x40   "icons_output/ios/Icon-App-40x40@1x.png"
$CMD "$MASTER_ICON" -resize 76x76   "icons_output/ios/Icon-App-76x76@1x.png"
$CMD "$MASTER_ICON" -resize 152x152 "icons_output/ios/Icon-App-76x76@2x.png"
$CMD "$MASTER_ICON" -resize 167x167 "icons_output/ios/Icon-App-83.5x83.5@2x.png"
# App Store
$CMD "$MASTER_ICON" -resize 1024x1024 "icons_output/ios/Icon-App-1024x1024@1x.png"
echo "  ✓ All iOS sizes generated"

# Android Icons
echo "🤖 Generating Android icons..."
mkdir -p icons_output/android/{mipmap-mdpi,mipmap-hdpi,mipmap-xhdpi,mipmap-xxhdpi,mipmap-xxxhdpi}
$CMD "$MASTER_ICON" -resize 48x48   "icons_output/android/mipmap-mdpi/ic_launcher.png"
$CMD "$MASTER_ICON" -resize 72x72   "icons_output/android/mipmap-hdpi/ic_launcher.png"
$CMD "$MASTER_ICON" -resize 96x96   "icons_output/android/mipmap-xhdpi/ic_launcher.png"
$CMD "$MASTER_ICON" -resize 144x144 "icons_output/android/mipmap-xxhdpi/ic_launcher.png"
$CMD "$MASTER_ICON" -resize 192x192 "icons_output/android/mipmap-xxxhdpi/ic_launcher.png"
echo "  ✓ All Android sizes generated"

# Linux Icons (optional)
echo "🐧 Generating Linux icons..."
mkdir -p icons_output/linux
for size in 32 64 128 256; do
    $CMD "$MASTER_ICON" -resize ${size}x${size} "icons_output/linux/${size}x${size}.png"
done
# SVG (copy original if you have SVG source, or create from PNG)
cp "$MASTER_ICON" "icons_output/linux/scalable.png"
echo "  ✓ All Linux sizes generated"

echo ""
echo "✅ All icons generated successfully!"
echo ""
echo "📁 Output directory: icons_output/"
echo ""
echo "Next steps:"
echo "1. Review generated icons in icons_output/"
echo "2. Run ./install_icons.sh to copy them to your project"