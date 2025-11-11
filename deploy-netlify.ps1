# Netlify deployment script for DictionaryDox

Write-Host "🚀 Starting DictionaryDox deployment to Netlify..." -ForegroundColor Green

# Check if build/web exists
if (Test-Path "build/web") {
    Write-Host "✅ Build directory found" -ForegroundColor Green
} else {
    Write-Host "❌ Build directory not found. Building now..." -ForegroundColor Red
    flutter build web --release
}

# Check if Netlify CLI is installed
try {
    netlify --version | Out-Null
    Write-Host "✅ Netlify CLI is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Netlify CLI not found. Installing..." -ForegroundColor Red
    Write-Host "Please run: npm install -g netlify-cli" -ForegroundColor Yellow
    exit 1
}

# Deploy to Netlify
Write-Host "📤 Deploying to Netlify..." -ForegroundColor Cyan
netlify deploy --prod --dir=build/web

Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host "🌐 Your app is now live on Netlify!" -ForegroundColor Magenta
