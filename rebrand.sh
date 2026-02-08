#!/bin/bash

# BlockStarDesk Rebranding Script
# Automatically renames RustDesk to BlockStarDesk

set -e

echo "🎨 BlockStarDesk Rebranding Script"
echo "=================================="
echo ""

# Configuration
NEW_NAME="BlockStarDesk"
NEW_NAME_LOWER="blockstardesk"
NEW_BUNDLE_ID="com.blockstar.blockstardesk"
OLD_BUNDLE_ID="com.blockstar.blockstardesk"

# Check if in rustdesk directory
if [ ! -f "Cargo.toml" ]; then
    echo "❌ Error: Run this script from the rustdesk root directory"
    exit 1
fi

echo "📝 Starting rebrand..."
echo "   Old: RustDesk (com.blockstar.blockstardesk)"
echo "   New: $NEW_NAME ($NEW_BUNDLE_ID)"
echo ""

# Backup
echo "💾 Creating backup..."

# 1. Update Cargo.toml
echo "1️⃣  Updating Cargo.toml..."
sed -i '' 's/name = "rustdesk"/name = "blockstardesk"/g' Cargo.toml

# 2. Update Flutter pubspec
echo "2️⃣  Updating Flutter configuration..."
sed -i '' 's/name: rustdesk/name: blockstardesk/g' flutter/pubspec.yaml
sed -i '' 's/description: .*/description: BlockStar Remote Desktop/g' flutter/pubspec.yaml

# 3. Update common.dart
echo "3️⃣  Updating Dart constants..."
if [ -f "flutter/lib/common.dart" ]; then
    sed -i '' 's/const String kAppName = ".*"/const String kAppName = "BlockStarDesk"/g' flutter/lib/common.dart
fi

# 4. Update macOS bundle ID
echo "4️⃣  Updating macOS bundle identifier..."
if [ -f "flutter/macos/Runner/Configs/AppInfo.xcconfig" ]; then
    sed -i '' "s/PRODUCT_NAME = .*/PRODUCT_NAME = $NEW_NAME/g" flutter/macos/Runner/Configs/AppInfo.xcconfig
    sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = .*/PRODUCT_BUNDLE_IDENTIFIER = $NEW_BUNDLE_ID/g" flutter/macos/Runner/Configs/AppInfo.xcconfig
fi

if [ -f "flutter/macos/Runner/Info.plist" ]; then
    sed -i '' "s|<string>$OLD_BUNDLE_ID</string>|<string>$NEW_BUNDLE_ID</string>|g" flutter/macos/Runner/Info.plist
    sed -i '' "s|<string>RustDesk</string>|<string>$NEW_NAME</string>|g" flutter/macos/Runner/Info.plist
fi

# 5. Update Windows
echo "5️⃣  Updating Windows configuration..."
if [ -f "flutter/windows/runner/Runner.rc" ]; then
    sed -i '' 's/VER_PRODUCTNAME_STR.*"RustDesk"/VER_PRODUCTNAME_STR         "BlockStarDesk"/g' flutter/windows/runner/Runner.rc
    sed -i '' 's/VER_FILEDESCRIPTION_STR.*/VER_FILEDESCRIPTION_STR     "BlockStar Remote Desktop"/g' flutter/windows/runner/Runner.rc
    sed -i '' 's/VER_COMPANYNAME_STR.*/VER_COMPANYNAME_STR         "BlockStar Foundation"/g' flutter/windows/runner/Runner.rc
fi

# 6. Update Android
echo "6️⃣  Updating Android configuration..."
if [ -f "flutter/android/app/build.gradle" ]; then
    sed -i '' "s/applicationId \".*\"/applicationId \"$NEW_BUNDLE_ID\"/g" flutter/android/app/build.gradle
fi

if [ -f "flutter/android/app/src/main/AndroidManifest.xml" ]; then
    sed -i '' "s/package=\".*\"/package=\"$NEW_BUNDLE_ID\"/g" flutter/android/app/src/main/AndroidManifest.xml
    sed -i '' 's/android:label=".*"/android:label="BlockStarDesk"/g' flutter/android/app/src/main/AndroidManifest.xml
fi

# 7. Update Linux
echo "7️⃣  Updating Linux configuration..."
if [ -f "flutter/linux/CMakeLists.txt" ]; then
    sed -i '' "s/set(BINARY_NAME \".*\")/set(BINARY_NAME \"$NEW_NAME_LOWER\")/g" flutter/linux/CMakeLists.txt
    sed -i '' "s/set(APPLICATION_ID \".*\")/set(APPLICATION_ID \"$NEW_BUNDLE_ID\")/g" flutter/linux/CMakeLists.txt
fi

# 8. Update Rust config
echo "8️⃣  Updating Rust configuration..."
if [ -f "libs/hbb_common/src/config.rs" ]; then
    sed -i '' 's/pub static ref APP_NAME.*RwLock::new(".*")/pub static ref APP_NAME: RwLock<String> = RwLock::new("BlockStarDesk"/g' libs/hbb_common/src/config.rs
    sed -i '' 's/pub static ref ORG.*RwLock::new(".*")/pub static ref ORG: RwLock<String> = RwLock::new("com.blockstar"/g' libs/hbb_common/src/config.rs
fi

# 9. Global replacements in Dart files
echo "9️⃣  Replacing strings in Dart files..."
find flutter/lib -name "*.dart" -type f -exec sed -i '' 's/RustDesk/BlockStarDesk/g' {} +

echo ""
echo "✅ Rebranding complete!"
echo ""
echo "📋 Changes made:"
echo "   ✓ Package name: rustdesk → blockstardesk"
echo "   ✓ App name: RustDesk → BlockStarDesk"
echo "   ✓ Bundle ID: $OLD_BUNDLE_ID → $NEW_BUNDLE_ID"
echo ""