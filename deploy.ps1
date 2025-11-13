#!/usr/bin/env pwsh
# Netlify Deploy Script for DictionaryDox

Write-Host "🚀 Starting deployment process..." -ForegroundColor Cyan

# Step 1: Build Flutter web
Write-Host "`n📦 Building Flutter web app..." -ForegroundColor Yellow
flutter build web --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Build completed successfully!" -ForegroundColor Green

# Step 2: Temporarily rename netlify.toml
Write-Host "`n🔄 Preparing for deployment..." -ForegroundColor Yellow
if (Test-Path "netlify.toml") {
    Rename-Item netlify.toml netlify.toml.bak
}

# Step 3: Deploy to Netlify
Write-Host "`n🌐 Deploying to Netlify..." -ForegroundColor Yellow
netlify deploy --prod --dir=build/web

$deployStatus = $LASTEXITCODE

# Step 4: Restore netlify.toml
if (Test-Path "netlify.toml.bak") {
    Rename-Item netlify.toml.bak netlify.toml
}

if ($deployStatus -eq 0) {
    Write-Host "`n✨ Deployment successful! 🎉" -ForegroundColor Green
    Write-Host "Your site is live at: https://dicitionarydox.uz" -ForegroundColor Cyan
} else {
    Write-Host "`n❌ Deployment failed!" -ForegroundColor Red
    exit 1
}
