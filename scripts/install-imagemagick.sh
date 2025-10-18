#!/bin/bash
# Helper script to install ImageMagick
# Run this manually if apply-branding.sh reports ImageMagick is missing

echo "📦 Installing ImageMagick..."
echo ""
echo "This script requires sudo privileges."
echo ""

sudo apt-get update
sudo apt-get install -y imagemagick

echo ""
echo "✅ ImageMagick installed successfully!"
echo ""
echo "Verify installation:"
convert --version | head -n 1
