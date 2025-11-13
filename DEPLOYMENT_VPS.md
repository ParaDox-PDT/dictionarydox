# VPS Server Deployment - dictionarydox.uz

Bu qo'llanma Flutter web ilovasini o'z serveringizda (VPS) host qilish uchun.

## 1. VPS Server Olish

### Ahost.uz (O'zbekiston)

1. [ahost.uz](https://ahost.uz) ga o'ting
2. **VPS** bo'limiga o'ting
3. Minimal plan tanlang:
   - **CPU**: 1 core
   - **RAM**: 1-2 GB
   - **SSD**: 20 GB
   - **OS**: Ubuntu 22.04 LTS
   - **Narx**: ~50,000 so'm/oy

4. **Buyurtma qilish** va to'lov
5. SSH access ma'lumotlarini oling:
   ```
   IP: 185.xxx.xxx.xxx
   User: root
   Password: [parolingiz]
   ```

### Boshqa providerlar

- **DigitalOcean**: https://digitalocean.com (Droplet)
- **Vultr**: https://vultr.com (Cloud Compute)
- **Hetzner**: https://hetzner.com (Cloud Server)

## 2. Domain Olish va Sozlash

### Domain Sotib Olish

1. **Uzregister.uz** (O'zbekiston):
   - [uzregister.uz](https://uzregister.uz)
   - `dictionarydox.uz` domenini tekshiring
   - Narx: ~50,000 so'm/yil

2. **Cloudflare** (Xalqaro):
   - Bepul SSL
   - CDN
   - DDoS himoya

### DNS Sozlash

Domeningiz providerida (Uzregister yoki Cloudflare):

```
Type: A
Name: @
Value: 185.xxx.xxx.xxx (VPS IP manzilingiz)
TTL: Auto

Type: A  
Name: www
Value: 185.xxx.xxx.xxx
TTL: Auto
```

## 3. Server Sozlash

### SSH orqali ulanish

Windows'da PowerShell:
```powershell
ssh root@185.xxx.xxx.xxx
# Parolni kiriting
```

### Server yangilash

```bash
# System yangilash
sudo apt update && sudo apt upgrade -y

# Nginx o'rnatish (web server)
sudo apt install nginx -y

# Certbot o'rnatish (SSL uchun)
sudo apt install certbot python3-certbot-nginx -y

# Git o'rnatish
sudo apt install git -y
```

## 4. Flutter Web Build

Local kompyuterda:

```bash
# Production build
flutter build web --release

# build/web papkasi yaratiladi
```

## 5. Fayllarni Serverga Yuklash

### Option 1: SCP (Tavsiya etiladi)

Windows PowerShell:
```powershell
# build/web papkasini serverga yuklash
scp -r build\web root@185.xxx.xxx.xxx:/var/www/dictionarydox
```

### Option 2: Git orqali

Server'da:
```bash
cd /var/www
git clone https://github.com/ParaDox-PDT/dictionarydox.git
cd dictionarydox
# Flutter o'rnatish kerak (yoki faqat build papkasini oling)
```

### Option 3: FTP/SFTP

- **FileZilla** yoki **WinSCP** ishlatish
- Host: `185.xxx.xxx.xxx`
- Protocol: SFTP
- Port: 22
- User/Password: SSH ma'lumotlari

## 6. Nginx Sozlash

Server'da:

```bash
# Nginx config yaratish
sudo nano /etc/nginx/sites-available/dictionarydox
```

Config faylga quyidagini yozing:

```nginx
server {
    listen 80;
    listen [::]:80;
    
    server_name dictionarydox.uz www.dictionarydox.uz;
    
    root /var/www/dictionarydox;
    index index.html;
    
    # Flutter web routing
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Cache static files
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript 
               application/x-javascript application/xml+rss 
               application/javascript application/json;
}
```

Saqlash: `Ctrl+X`, `Y`, `Enter`

### Config aktivlashtirish

```bash
# Symbolic link yaratish
sudo ln -s /etc/nginx/sites-available/dictionarydox /etc/nginx/sites-enabled/

# Default config o'chirish (agar kerak bo'lsa)
sudo rm /etc/nginx/sites-enabled/default

# Nginx test
sudo nginx -t

# Nginx restart
sudo systemctl restart nginx
```

## 7. SSL Sertifikat (HTTPS)

Certbot bilan bepul SSL:

```bash
# SSL o'rnatish
sudo certbot --nginx -d dictionarydox.uz -d www.dictionarydox.uz

# Email kiriting
# Terms of Service'ga agree
# Avtomatik HTTP→HTTPS redirect (2 tanlang)
```

SSL avtomatik yangilanadi (Certbot cron job o'rnatadi).

## 8. Firewall Sozlash

```bash
# UFW o'rnatish
sudo apt install ufw -y

# SSH ruxsat (muhim!)
sudo ufw allow 22/tcp

# HTTP va HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Firewall yoqish
sudo ufw enable

# Status tekshirish
sudo ufw status
```

## 9. Firebase Authorized Domains

Firebase Console'da domeningizni qo'shing:

1. [Firebase Console](https://console.firebase.google.com) → dictionarydox
2. **Authentication** → **Settings** → **Authorized domains**
3. **Add domain** → `dictionarydox.uz`

## 10. Google OAuth Redirect URIs

Google Cloud Console:

1. [console.cloud.google.com](https://console.cloud.google.com)
2. **APIs & Services** → **Credentials**
3. OAuth 2.0 Client ID → Web client
4. **Authorized JavaScript origins**:
   - `https://dictionarydox.uz`
5. **Authorized redirect URIs**:
   - `https://dictionarydox.uz/__/auth/handler`

## 11. Deploy Script Yaratish

Local'da `deploy.ps1` (PowerShell):

```powershell
# Flutter build
Write-Host "Building Flutter web..." -ForegroundColor Green
flutter build web --release

# Upload to server
Write-Host "Uploading to server..." -ForegroundColor Green
scp -r build\web\* root@185.xxx.xxx.xxx:/var/www/dictionarydox/

Write-Host "Deployment complete!" -ForegroundColor Green
Write-Host "Visit: https://dictionarydox.uz" -ForegroundColor Cyan
```

Ishlatish:
```powershell
.\deploy.ps1
```

## 12. Monitoring va Maintenance

### Nginx Logs

```bash
# Access log
sudo tail -f /var/log/nginx/access.log

# Error log
sudo tail -f /var/log/nginx/error.log
```

### Server Status

```bash
# Nginx status
sudo systemctl status nginx

# Server resources
htop
# yoki
free -h
df -h
```

### SSL Renewal Test

```bash
# SSL yangilanishini test qilish
sudo certbot renew --dry-run
```

## 13. Yangilash (Updates)

Har safar kod o'zgartirsangiz:

```bash
# 1. Local: Build
flutter build web --release

# 2. Upload
scp -r build\web\* root@185.xxx.xxx.xxx:/var/www/dictionarydox/

# 3. Server: Cache tozalash (agar kerak bo'lsa)
# SSH orqali:
sudo systemctl reload nginx
```

## 14. Performance Optimization

### Nginx caching

```nginx
# /etc/nginx/nginx.conf ga qo'shing
http {
    # Cache settings
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m max_size=1g inactive=60m;
    
    # Existing config...
}
```

### Gzip compression

Allaqachon yuqoridagi Nginx config'da bor.

## 15. Backup

```bash
# Backup yaratish
sudo tar -czf /backup/dictionarydox-$(date +%Y%m%d).tar.gz /var/www/dictionarydox

# Backup yuklab olish (local)
scp root@185.xxx.xxx.xxx:/backup/dictionarydox-*.tar.gz ./backups/
```

## Troubleshooting

### Site ochilmayapti:
```bash
# Nginx status
sudo systemctl status nginx

# Nginx restart
sudo systemctl restart nginx

# Error log
sudo tail -f /var/log/nginx/error.log
```

### SSL muammosi:
```bash
# SSL yangilash
sudo certbot renew

# Nginx restart
sudo systemctl restart nginx
```

### Permission error:
```bash
# Fayl ruxsatlarini tuzatish
sudo chown -R www-data:www-data /var/www/dictionarydox
sudo chmod -R 755 /var/www/dictionarydox
```

## Narxlar (O'zbekiston)

| Xizmat | Provider | Narx/oy |
|--------|----------|---------|
| VPS (1GB RAM) | Ahost.uz | ~50,000 so'm |
| Domain (.uz) | Uzregister | ~4,000 so'm (~50k/yil) |
| SSL | Let's Encrypt | BEPUL |
| **JAMI** | | **~54,000 so'm/oy** |

## Production Checklist

- [ ] VPS server olindi
- [ ] Domain sotib olindi (dictionarydox.uz)
- [ ] DNS sozlandi (A record)
- [ ] Server yangilandi (apt update)
- [ ] Nginx o'rnatildi va sozlandi
- [ ] SSL sertifikat o'rnatildi (HTTPS)
- [ ] Firewall sozlandi (UFW)
- [ ] Flutter web build qilindi
- [ ] Fayllar serverga yuklandi
- [ ] Firebase authorized domain qo'shildi
- [ ] Google OAuth redirect URIs qo'shildi
- [ ] Test qilindi - site ishlayapti
- [ ] Google Sign-In ishlayapti

## Foydali Buyruqlar

```bash
# Nginx
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl status nginx
sudo nginx -t  # Config test

# SSL
sudo certbot renew
sudo certbot certificates

# Server
htop  # Resources
df -h  # Disk space
free -h  # Memory
```

---

**Eslatma**: Bu qo'llanma O'zbekiston uchun optimallashtirilgan. Ahost.uz va Uzregister.uz O'zbekiston providerlardir, to'lov so'm'da.

**Server joylashuvi**: O'zbekistonda server bo'lsa, tezroq ishlaydi (past ping).
