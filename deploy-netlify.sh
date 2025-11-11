#!/bin/bash
# Netlify deployment script for DictionaryDox (Linux/Mac)

echo "🚀 Starting DictionaryDox deployment to Netlify..."

# Check if build/web exists
if [ -d "build/web" ]; then
    echo "✅ Build directory found"
else
    echo "❌ Build directory not found. Building now..."
    flutter build web --release
fi

# Check if Netlify CLI is installed
if command -v netlify &> /dev/null; then
    echo "✅ Netlify CLI is installed"
else
    echo "❌ Netlify CLI not found. Installing..."
    echo "Please run: npm install -g netlify-cli"
    exit 1
fi

# Deploy to Netlify
echo "📤 Deploying to Netlify..."
netlify deploy --prod --dir=build/web

echo "✅ Deployment complete!"
echo "🌐 Your app is now live on Netlify!"
