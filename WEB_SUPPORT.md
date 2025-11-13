# DictionaryDox - Web Support 🌐

Bu loyiha endi to'liq web platformasini qo'llab-quvvatlaydi! Barcha functionality mobilga o'xshash ishlaydi.

## ✨ Web uchun qo'shilgan imkoniyatlar

### 📦 Storage
- **Mobile**: Hive (lokal database)
- **Web**: SharedPreferences (Local Storage)
- Ma'lumotlar brauzerning local storage'ida saqlanadi
- Refresh qilsangiz ham ma'lumotlar saqlanib qoladi

### 🎨 Responsive UI
- **Desktop** (900px+): Grid layout, 3 ustunli
- **Tablet** (600-900px): 2 ustunli layout
- **Mobile** (<600px): Bitta ustunli list layout
- Barcha sahifalar ekran o'lchamiga avtomatik moslashadi

### 🚀 Web'da ishlaydigan funksiyalar
✅ Unit yaratish va o'chirish
✅ So'z qo'shish (validation, image search)
✅ So'zlarni ko'rish (list va carousel view)
✅ Quiz funksiyalari
✅ TTS (Text-to-Speech) - so'zlarni talaffuz qilish
✅ Audio playback
✅ Image loading va caching

## 📱 Ishga tushirish

### Web versiyasini local'da ishlatish:
```bash
flutter run -d chrome
```

### Web'ni build qilish:
```bash
flutter build web --release
```

Build natijasi `build/web` papkasida bo'ladi.

### Hosting qilish
Build qilingan `build/web` papkasini istalgan static hosting'ga deploy qilishingiz mumkin:
- Firebase Hosting
- Netlify
- Vercel
- GitHub Pages
- va boshqalar

## 🔧 Texnik tafsilotlar

### Platform Detection
Kod avtomatik ravishda platformani aniqlaydi va mos storage'dan foydalanadi:
- Web: `SharedPreferences` (browser local storage)
- Mobile/Desktop: `Hive` (lokal database)

### Responsive Layout
```dart
// Desktop uchun grid layout
if (ResponsiveUtils.isDesktop(context)) {
  return GridView(...);
}
// Mobile uchun list
return ListView(...);
```

### Storage Abstraction
```dart
abstract class StorageService {
  Future<void> init();
  Future<void> put<T>(String key, T value);
  T? get<T>(String key);
  // ...
}
```

## 📝 Muhim eslatmalar

1. **Browser Compatibility**: 
   - Chrome ✅
   - Firefox ✅
   - Safari ✅
   - Edge ✅

2. **Storage Limits**:
   - Web local storage ~5-10MB
   - Juda ko'p ma'lumot saqlashda ehtiyot bo'ling

3. **Audio/TTS**:
   - TTS barcha brauzerda ishlaydi
   - Audio playback ham barcha zamonaviy brauzerda qo'llab-quvvatlanadi

## 🎯 Kelajak rejalar

- [ ] PWA (Progressive Web App) qilish
- [ ] Offline support
- [ ] Cloud sync (Firebase/Supabase)
- [ ] Multi-language support

## 🐛 Bug Report
Agar muammo topsangiz, GitHub Issues'ga xabar bering.

---
Made with ❤️ using Flutter & Clean Architecture
