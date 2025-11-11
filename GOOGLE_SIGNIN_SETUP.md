# Google Sign-In Setup for Android

## SHA-1 Fingerprint Olish

### Debug SHA-1:
```bash
cd android
./gradlew signingReport
```

Yoki:
```bash
keytool -list -v -keystore C:\Users\%USERNAME%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### SHA-1 ni Firebase'ga qo'shish:

1. Firebase Console'ga kiring
2. Project Settings > General
3. "Your apps" bo'limida Android app'ingizni tanlang
4. SHA certificate fingerprints bo'limida "Add fingerprint" tugmasini bosing
5. SHA-1 ni kiriting va save qiling

### google-services.json yangilash:

SHA-1 qo'shgandan keyin Firebase Console'dan yangi `google-services.json` yuklab oling va `android/app/` papkasiga joylashtiring.

## Web uchun:

Firebase Console > Settings > General > Web apps
- Web client ID ni copy qiling

`android/app/src/main/res/values/strings.xml` yarating va quyidagini qo'shing:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="default_web_client_id">YOUR_WEB_CLIENT_ID</string>
</resources>
```

## Test qilish:

1. Android qurilmada yoki emulatorida ishga tushiring
2. Login page'da "Sign in with Google" tugmasini bosing
3. Google akkountingizni tanlang
4. Tizimga kiring

## Muhim:

- Debug build uchun debug SHA-1
- Release build uchun release SHA-1 kerak
- Har bir build type uchun alohida SHA-1 qo'shing
