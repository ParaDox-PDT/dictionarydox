# Firebase Cloud Messaging (FCM) Setup Guide

## Firebase konfiguratsiyasi to'liq o'rnatildi! ✅

### O'rnatilgan komponentlar:

1. **NotificationService** - Barcha platformalarda ishlaydigan (Android, iOS, Web)
2. **Firebase Core** - Firebase asosiy kutubxonasi
3. **Firebase Messaging** - Push notification servisi
4. **Flutter Local Notifications** - Local notificationlar uchun

---

## 📱 Qo'shimcha sozlash kerak bo'lgan qismlar

### 1. iOS uchun GoogleService-Info.plist fayli

iOS da ishlashi uchun `GoogleService-Info.plist` faylini Firebase Console dan yuklab olish kerak:

1. Firebase Console ga kiring: https://console.firebase.google.com
2. Proyektingizni tanlang (dictionarydox)
3. Settings (sozlamalar) > General
4. iOS apps bo'limida `app.dicitionarydox.uz` app'ingizni toping
5. `GoogleService-Info.plist` faylini yuklab oling
6. Faylni `ios/Runner/` papkasiga joylashtiring

```bash
# Terminal dan
mv ~/Downloads/GoogleService-Info.plist ios/Runner/
```

**Xcode orqali:**
1. Xcode da proyektni oching
2. `Runner` target'ini tanlang
3. `GoogleService-Info.plist` faylini drag & drop qiling
4. "Copy items if needed" checkboxini belgilang

---

### 2. Web uchun VAPID Key

Web platformada push notification ishlashi uchun VAPID key kerak:

1. Firebase Console > Settings > Cloud Messaging
2. Web Push certificates bo'limiga o'ting
3. Agar key yo'q bo'lsa, "Generate key pair" bosing
4. Key pair'ni copy qiling

**Faylda yangilash:**
`lib/src/core/services/notification_service.dart` faylini oching va quyidagi qatorni toping:

```dart
vapidKey: 'YOUR_VAPID_KEY_HERE', // Replace with your VAPID key
```

VAPID key'ingizni shu yerga qo'ying:

```dart
vapidKey: 'BNJx...your-actual-vapid-key', // Your VAPID key
```

---

## 🚀 Qanday ishlatish

### 1. Paketlarni o'rnating

```bash
flutter pub get
```

### 2. App ni ishga tushiring

```bash
# Android
flutter run

# iOS (Mac kerak)
flutter run -d ios

# Web
flutter run -d chrome
```

---

## 📨 FCM Token olish

App ishga tushgandan keyin, console da FCM token chop etiladi:

```
FCM Token: fGH7kL9mN2pQ...
```

Bu token'ni serveringizga yuboring va notification yuborish uchun ishlating.

---

## 🧪 Notification test qilish

### Firebase Console orqali

1. Firebase Console > Cloud Messaging
2. "Send your first message" bosing
3. Notification title va body kiriting
4. "Send test message" bosing
5. FCM token'ingizni kiriting va "Test" bosing

### Topic subscription

```dart
// Topic'ga obuna bo'lish
await NotificationService().subscribeToTopic('all_users');

// Topic'dan chiqish
await NotificationService().unsubscribeFromTopic('all_users');
```

### Notification message stream

```dart
// Notification message kelganda tinglash
NotificationService().messageStream.listen((RemoteMessage message) {
  print('Notification keldi: ${message.notification?.title}');
  // Custom logic...
});
```

---

## 📋 Notification turlari

### 1. Foreground notification
App ochiq bo'lganda notification kelsa, avtomatik ravishda local notification ko'rsatiladi.

### 2. Background notification
App background'da bo'lsa, notification tray'da ko'rsatiladi.

### 3. Terminated notification
App to'liq yopilgan bo'lsa ham notification ishlaydi.

---

## 🔧 Muammolarni bartaraf etish

### Android

**Notification ko'rinmayapti:**
- Android 13+ da runtime permission kerak
- Settings > Apps > DictionaryDox > Notifications - enable qiling

**Build xatoligi:**
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean
cd ..
flutter run
```

### iOS

**Token null qaytaryapti:**
- GoogleService-Info.plist fayli to'g'ri joylashganligini tekshiring
- Xcode da "Runner" target'da fayl ko'rinishini tasdiqlang
- Capabilities > Push Notifications - enable qiling
- Capabilities > Background Modes > Remote notifications - enable qiling

**APNs token xatoligi:**
- Real qurilmada test qiling (simulator ishlamaydi)
- Developer account kerak

### Web

**Service worker registratsiya qilmayapti:**
- HTTPS kerak (localhost bundan mustasno)
- Browser console'da xatolarni tekshiring
- `firebase-messaging-sw.js` fayli to'g'ri joylashganligini tasdiqlang

---

## 📊 Server tarafda notification yuborish

### cURL orqali

```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "Yangi so'\''z!",
      "body": "Bugun 5 ta yangi so'\''z qo'\''shildi"
    },
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "route": "/words"
    }
  }'
```

### Topic'ga yuborish

```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "/topics/all_users",
    "notification": {
      "title": "Yangilanish!",
      "body": "Yangi versiya chiqdi"
    }
  }'
```

---

## ✨ Qo'shimcha funksiyalar

### Custom notification handler

`lib/src/core/services/notification_service.dart` faylida:

```dart
void _handleNotificationTap(RemoteMessage message) {
  // Custom navigation
  final route = message.data['route'];
  if (route != null) {
    // Navigate to route
    // router.push(route);
  }
}
```

### Badge count (iOS)

```dart
// iOS badge count o'rnatish
if (Platform.isIOS) {
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.setBadgeNumber(5);
}
```

---

## 📝 Eslatmalar

- **Android 13+**: Runtime notification permission so'rash kerak
- **iOS**: Real device kerak (simulator FCM ishlamaydi)
- **Web**: HTTPS va VAPID key majburiy
- **Background messages**: Top-level function bo'lishi kerak

---

## 🎯 Keyingi qadamlar

1. ✅ Firebase paketlarini o'rnatish - **BAJARILDI**
2. ✅ NotificationService yaratish - **BAJARILDI**
3. ✅ Android konfiguratsiya - **BAJARILDI**
4. ✅ iOS konfiguratsiya - **BAJARILDI**
5. ✅ Web konfiguratsiya - **BAJARILDI**
6. ⏳ GoogleService-Info.plist yuklab olish - **SIZ BAJARASIZ**
7. ⏳ VAPID key qo'shish - **SIZ BAJARASIZ**
8. ⏳ Test qilish - **SIZ BAJARASIZ**

---

Omad! 🚀
