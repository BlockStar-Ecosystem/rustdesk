#!/bin/bash

# BlockStarDesk macOS Quick Fix
# This script fixes the "app cannot be opened" issue

echo "🔧 BlockStarDesk macOS Quick Fix"
echo "================================"
echo ""

APP_PATH="/Applications/BlockStarDesk.app"

# Check if app exists
if [ ! -d "$APP_PATH" ]; then
    echo "❌ BlockStarDesk.app not found in /Applications/"
    echo "Please make sure the app is installed first."
    exit 1
fi

echo "✅ Found BlockStarDesk.app"
echo ""

# Step 1: Remove quarantine
echo "Step 1: Removing quarantine attribute..."
sudo xattr -cr "$APP_PATH"
echo "✅ Quarantine removed"
echo ""

# Step 2: Remove existing signatures
echo "Step 2: Removing old signatures..."
sudo codesign --remove-signature "$APP_PATH" 2>/dev/null
echo "✅ Old signatures removed"
echo ""

# Step 3: Make executable
echo "Step 3: Making executable..."
sudo chmod +x "$APP_PATH/Contents/MacOS/BlockStarDesk"
echo "✅ Executable permissions set"
echo ""

# Step 4: Sign frameworks
echo "Step 4: Signing frameworks..."
find "$APP_PATH/Contents/Frameworks" -name "*.framework" -exec sudo codesign --force --sign - {} \; 2>/dev/null
find "$APP_PATH/Contents/Frameworks" -name "*.dylib" -exec sudo codesign --force --sign - {} \; 2>/dev/null
echo "✅ Frameworks signed"
echo ""

# Step 5: Sign main app
echo "Step 5: Signing main app..."
sudo codesign --force --deep --sign - "$APP_PATH"
echo "✅ Main app signed"
echo ""

# Step 6: Try to open
echo "Step 6: Attempting to open app..."
open "$APP_PATH"

echo ""
echo "📋 Next Steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "If you see an error dialog, follow these steps:"
echo ""
echo "1. The app will fail to open (this is expected)"
echo ""
echo "2. Open System Settings (or System Preferences)"
echo ""
echo "3. Go to: Privacy & Security"
echo ""
echo "4. Scroll down to Security section"
echo ""
echo "5. You'll see: 'BlockStarDesk was blocked from use'"
echo ""
echo "6. Click the 'Open Anyway' button"
echo ""
echo "7. Click 'Open' in the confirmation dialog"
echo ""
echo "8. Done! The app should now open."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 Alternative: Right-click the app and select 'Open'"
echo ""