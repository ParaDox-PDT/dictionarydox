# Netlify Deployment Guide - DictionaryDox

Bu qo'llanma DictionaryDox Flutter web ilovasini Netlify'ga deploy qilish uchun.

## 1. Netlify Account Yaratish

1. [Netlify.com](https://www.netlify.com) ga o'ting
2. **Sign up** tugmasini bosing
3. GitHub akkount bilan ro'yxatdan o'ting (tavsiya etiladi)

## 2. Flutter Web Build Qilish

Terminalda quyidagi buyruqlarni bajaring:

```bash
# Build qilish
flutter build web --release

# Build fayllari `build/web` papkasida saqlanadi
```

## 3. Netlify'ga Deploy Qilish (3 ta usul)

### A. GitHub orqali (Tavsiya etiladi - Auto deploy)

1. **Netlify Dashboard**'ga o'ting
2. **Add new site** → **Import an existing project**
3. **GitHub**'ni tanlang
4. Repository'ni toping va tanlang: `ParaDox-PDT/dictionarydox`
5. Build settings:
   - **Build command**: `flutter build web --release`
   - **Publish directory**: `build/web`
   - **Base directory**: (bo'sh qoldiring)
6. **Deploy site** bosing

**Avval CI/CD setup kerak:**
- GitHub repository Settings → Secrets → New secret
- `FLUTTER_VERSION`: `3.35.7` qo'shing

### B. Netlify CLI orqali

```bash
# Netlify CLI'ni o'rnatish
npm install -g netlify-cli

# Login qilish
netlify login

# Deploy qilish
netlify deploy --dir=build/web --prod
```

### C. Manual Upload (Eng oson)

1. **Netlify Dashboard** → **Sites** → **Add new site** → **Deploy manually**
2. `build/web` papkasini drag & drop qiling
3. Deploy tugashi kutiladi

## 4. Custom Domain Sozlash (Ixtiyoriy)

1. Netlify Dashboard → **Domain settings**
2. **Add custom domain** bosing
3. Domeningizni kiriting (masalan: `dictionarydox.uz`)
4. DNS providerda Netlify ko'rsatmalariga amal qiling:
   - **A record**: `75.2.60.5`
   - **CNAME**: `[your-site].netlify.app`

## 5. Firebase Web Configuration

Web'da Google Sign-In ishlashi uchun Firebase konfiguratsiya kerak.

### Firebase Console Setup:

1. [Firebase Console](https://console.firebase.google.com) → dictionarydox
2. **Project Settings** → **General**
3. **Your apps** → **Web app** (</>) belgisini bosing
4. **Authorized domains**'ga Netlify domenini qo'shing:
   - `[your-site].netlify.app`
   - Agar custom domain bo'lsa: `dictionarydox.uz`

### Google OAuth Setup:

1. [Google Cloud Console](https://console.cloud.google.com)
2. **APIs & Services** → **Credentials**
3. **OAuth 2.0 Client IDs** → Web client
4. **Authorized JavaScript origins**:
   - `https://[your-site].netlify.app`
   - `https://dictionarydox.uz` (agar custom domain bo'lsa)
5. **Authorized redirect URIs**:
   - `https://[your-site].netlify.app/__/auth/handler`
   - `https://dictionarydox.firebaseapp.com/__/auth/handler`

## 6. Environment Variables (Agar kerak bo'lsa)

Netlify Dashboard → **Site settings** → **Environment variables**

```
FLUTTER_VERSION=3.35.7
NODE_VERSION=18
```

## 7. Build Optimization

`netlify.toml` fayli allaqachon mavjud va sozlangan:

```toml
[build]
  command = "flutter build web --release"
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
```

## 8. Test Qilish

Deploy tugagach:

1. Netlify'dan berilgan URL'ni oching (masalan: `https://dictionarydox.netlify.app`)
2. Login page ochilishini tekshiring
3. Google Sign-In tugmasini bosing
4. Google akkount bilan kiring
5. Home page ochilishini tekshiring

## 9. Continuous Deployment

GitHub'ga push qilganingizda avtomatik deploy bo'ladi:

```bash
git add .
git commit -m "Update app"
git push origin main

# Netlify avtomatik build va deploy qiladi
```

## 10. Monitoring

- **Build logs**: Netlify Dashboard → **Deploys** → Deploy'ni tanlang
- **Function logs**: Netlify Dashboard → **Functions**
- **Analytics**: Netlify Dashboard → **Analytics** (Pro plan kerak)

## Troubleshooting

### Build muvaffaqiyatsiz:
- Netlify'da Flutter o'rnatilmagan bo'lishi mumkin
- `netlify.toml` faylini tekshiring
- Build command to'g'riligini tasdiqlang

### Google Sign-In ishlamayapti:
- Firebase Console'da authorized domains tekshiring
- Google Cloud Console'da OAuth redirect URIs to'g'riligini tasdiqlang
- Browser console'da xatolarni o'qing

### 404 Error:
- `netlify.toml` da redirects sozlangan bo'lishi kerak
- `/index.html` ga redirect qilishi kerak

## Production Checklist

- [ ] `flutter build web --release` muvaffaqiyatli
- [ ] Firebase authorized domains to'g'ri sozlangan
- [ ] Google OAuth redirect URIs qo'shilgan
- [ ] Custom domain (agar kerak bo'lsa) sozlangan
- [ ] SSL sertifikat aktiv (Netlify avtomatik beradi)
- [ ] Test qilingan - login/logout ishlayapti
- [ ] Performance tekshirilgan (Lighthouse)

## Foydali Linklar

- **Netlify Docs**: https://docs.netlify.com
- **Firebase Hosting**: https://firebase.google.com/docs/hosting
- **Flutter Web**: https://docs.flutter.dev/deployment/web
- **Your Netlify Site**: [Deploy qilgandan keyin URL](https://app.netlify.com)

---

**Eslatma**: Netlify bepul plan:
- 100 GB bandwidth/oy
- 300 build minutes/oy
- Avtomatik SSL
- Custom domain support
- Continuous deployment

Production uchun bu yetarli!
