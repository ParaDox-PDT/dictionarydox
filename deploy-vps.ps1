# Deploy Flutter Web to VPS Server
# Bu script Flutter web ilovasini build qilib, serverga yuklaydi

param(
    [string]$ServerIP = "",
    [string]$ServerUser = "root",
    [string]$ServerPath = "/var/www/dictionarydox"
)

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host " DictionaryDox Web Deployment" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if server IP provided
if ([string]::IsNullOrEmpty($ServerIP)) {
    $ServerIP = Read-Host "Server IP manzilini kiriting (masalan: 185.xxx.xxx.xxx)"
}

# Confirm deployment
Write-Host "Server: $ServerUser@$ServerIP" -ForegroundColor Yellow
Write-Host "Path: $ServerPath" -ForegroundColor Yellow
$confirm = Read-Host "Deploy qilishni davom ettirasizmi? (y/n)"
if ($confirm -ne "y") {
    Write-Host "Deployment bekor qilindi." -ForegroundColor Red
    exit
}

Write-Host ""

# Step 1: Clean previous build
Write-Host "[1/5] Cleaning previous build..." -ForegroundColor Green
if (Test-Path "build\web") {
    Remove-Item -Recurse -Force "build\web"
}

# Step 2: Flutter build
Write-Host "[2/5] Building Flutter web (release mode)..." -ForegroundColor Green
flutter build web --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

# Step 3: Check build output
if (-not (Test-Path "build\web\index.html")) {
    Write-Host "Build output not found!" -ForegroundColor Red
    exit 1
}

Write-Host "[3/5] Build successful! Files ready in build\web\" -ForegroundColor Green

# Step 4: Create backup on server (optional)
Write-Host "[4/5] Creating backup on server..." -ForegroundColor Green
$backupDate = Get-Date -Format "yyyyMMdd_HHmmss"
$backupCmd = "if [ -d $ServerPath ]; then tar -czf /tmp/dictionarydox_backup_$backupDate.tar.gz -C $ServerPath . ; fi"
ssh "$ServerUser@$ServerIP" $backupCmd

# Step 5: Upload files to server
Write-Host "[5/5] Uploading to server..." -ForegroundColor Green
scp -r build\web\* "$ServerUser@${ServerIP}:$ServerPath/"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Upload failed!" -ForegroundColor Red
    exit 1
}

# Reload Nginx
Write-Host "Reloading Nginx..." -ForegroundColor Green
ssh "$ServerUser@$ServerIP" "sudo systemctl reload nginx"

# Complete
Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host " Deployment Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your site is live at:" -ForegroundColor Cyan
Write-Host "https://dictionarydox.uz" -ForegroundColor White
Write-Host ""
Write-Host "Backup saved: /tmp/dictionarydox_backup_$backupDate.tar.gz" -ForegroundColor Yellow
Write-Host ""
