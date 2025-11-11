# Firebase Cloud Messaging - O'zbekcha Qo'llanma

## ✅ Nima qilindi?

### 1. Paketlar qo'shildi
- `firebase_core` - Firebase asosiy kutubxona
- `firebase_messaging` - Push notificationlar uchun
- `flutter_local_notifications` - Local notificationlar uchun

### 2. NotificationService yaratildi
- **Path**: `lib/src/core/services/notification_service.dart`
- Barcha platformalarda ishlaydi (Android, iOS, Web)
- Singleton pattern bilan yaratilgan
- FCM token olish
- Foreground, background va terminated holatda notificationlar qabul qilish
- Topic subscription/unsubscription
- Local notification ko'rsatish

### 3. Platform konfiguratsiyalari

#### Android ✅
- `android/app/build.gradle.kts` - Google Services plugin qo'shilgan
- `android/settings.gradle.kts` - Google Services plugin versiyasi
- `AndroidManifest.xml` - Notification permissionlari va meta-datalar
- `google-services.json` fayli mavjud

#### iOS ✅
- `ios/Runner/Info.plist` - Background modes va FCM konfiguratsiya
- `ios/Runner/AppDelegate.swift` - Firebase messaging sozlamalari
- ⚠️ **KERAK**: `GoogleService-Info.plist` faylini Firebase Console dan yuklab olish

#### Web ✅
- `web/firebase-messaging-sw.js` - Service worker yaratildi
- `web/index.html` - Service worker registratsiya qilindi
- ⚠️ **KERAK**: VAPID key qo'shish (`notification_service.dart` da)

### 4. Main.dart yangilandi
- Firebase initialize qilindi
- Background message handler sozlandi
- NotificationService ishga tushirildi

### 5. Test page yaratildi
- **Path**: `lib/src/presentation/pages/notification_test_page.dart`
- FCM token ko'rsatish va copy qilish
- Topic'ga subscribe/unsubscribe
- Kelgan notificationlarni ko'rish

---

## 🚀 Qanday ishlatish

### 1. iOS uchun GoogleService-Info.plist

```bash
# Firebase Console dan yuklab oling va qo'ying:
ios/Runner/GoogleService-Info.plist
```

### 2. Web uchun VAPID key

Firebase Console > Settings > Cloud Messaging > Web Push certificates

Keyin `lib/src/core/services/notification_service.dart` faylida:
```dart
// Qator 184-185
vapidKey: 'YOUR_VAPID_KEY_HERE', // Bu yerga VAPID key qo'ying
```

### 3. App ishga tushiring

```bash
flutter run
```

### 4. Test qilish

1. Console da FCM token chiqadi:
```
FCM Token: fGH7kL9mN2pQ...
```

2. Firebase Console > Cloud Messaging > Send test message
3. FCM token'ni kiriting va "Test" bosing

---

## 📱 NotificationService API

### Initialize
```dart
await NotificationService().initialize();
```

### FCM Token olish
```dart
String? token = NotificationService().fcmToken;
```

### Topic subscription
```dart
await NotificationService().subscribeToTopic('all_users');
await NotificationService().unsubscribeFromTopic('all_users');
```

### Message stream
```dart
NotificationService().messageStream.listen((RemoteMessage message) {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
});
```

---

## 🔔 Notification holatlari

### Foreground (App ochiq)
- Notification olinadi
- Local notification ko'rsatiladi
- `onMessage` stream ishga tushadi

### Background (App orqada)
- Notification tray'da ko'rsatiladi
- Tap qilganda `onMessageOpenedApp` ishga tushadi

### Terminated (App yopilgan)
- Notification tray'da ko'rsatiladi
- Tap qilganda `getInitialMessage` ishga tushadi

---

## 🧪 Test page

Test page'ni ko'rish uchun routerni yangilang yoki to'g'ridan-to'g'ri navigate qiling:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NotificationTestPage(),
  ),
);
```

---

## ⚠️ Muhim eslatmalar

1. **iOS**:
   - GoogleService-Info.plist majburiy
   - Real device kerak (simulator ishlamaydi)
   - Xcode da Push Notifications capability enable qiling

2. **Web**:
   - VAPID key majburiy
   - HTTPS kerak (localhost bundan mustasno)
   - Service worker to'g'ri registratsiya qilinganligini tekshiring

3. **Android 13+**:
   - Runtime notification permission so'raladi
   - Settings dan manual enable qilish mumkin

---

## 📊 Keyingi qadamlar

- [ ] GoogleService-Info.plist yuklab olish (iOS)
- [ ] VAPID key qo'shish (Web)
- [ ] Test notification yuborish
- [ ] Server integration (FCM token'ni backend'ga yuborish)
- [ ] Custom notification handler (navigation, badge, etc.)
- [ ] Production APNs sertifikatlarini sozlash (iOS)

---

## 🆘 Yordam

Batafsil qo'llanma: `FCM_SETUP.md`

Muammolar yuzaga kelsa:
1. `flutter clean && flutter pub get`
2. Android: `cd android && ./gradlew clean`
3. Console da xatolarni o'qing
4. FCM_SETUP.md faylini tekshiring

---

Omad! 🎉
