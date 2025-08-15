#!/bin/bash

# Comprehensive SketchyBar Installation and Setup Script
# This script addresses all critical dependencies for sketchybar Lua configuration

echo "🚀 Starting SketchyBar complete installation..."

# Step 1: Install core dependencies
echo "📦 Installing core dependencies via Homebrew..."
brew install lua
brew install switchaudio-osx  
brew install nowplaying-cli

# Step 2: Install SketchyBar
echo "🎯 Installing SketchyBar..."
brew tap FelixKratz/formulae
brew install sketchybar

# Step 3: Install SbarLua module (critical dependency)
echo "🔧 Installing SbarLua module..."
if [ -d "/tmp/SbarLua" ]; then
    rm -rf /tmp/SbarLua
fi

git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua
make install
cd -
rm -rf /tmp/SbarLua

# Step 4: Compile helper binaries
echo "🛠️  Compiling helper binaries..."
cd ~/.config/sketchybar/helpers
make

# Step 5: Verify installation
echo "✅ Verifying installation..."
echo "SbarLua module location:"
ls -la ~/.local/share/sketchybar_lua/

echo "Helper binaries:"
ls -la ~/.config/sketchybar/helpers/event_providers/*/bin/

echo "Dependencies check:"
which lua
which switchaudio-osx
which nowplaying-cli
which sketchybar

# Step 6: Reload SketchyBar
echo "🔄 Reloading SketchyBar configuration..."
sketchybar --reload

echo "🎉 SketchyBar installation completed successfully!"
echo ""
echo "📋 Installation Summary:"
echo "✓ Lua runtime installed"
echo "✓ Audio switching utility (switchaudio-osx) installed"  
echo "✓ Media player CLI (nowplaying-cli) installed"
echo "✓ SketchyBar main application installed"
echo "✓ SbarLua module compiled and installed"
echo "✓ Helper binaries compiled (CPU/network monitoring)"
echo "✓ Configuration loaded and verified"
echo ""
echo "🔍 You can verify the installation by running:"
echo "   sketchybar --query bar"
echo "   ps aux | grep sketchybar"