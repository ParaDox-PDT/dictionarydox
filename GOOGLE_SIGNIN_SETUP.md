# Google Sign-In Setup Guide

## Android Setup

### 1. Get SHA-1 Fingerprint
```bash
cd android
./gradlew signingReport
```

**Your SHA-1:**
```
FF:1F:9E:1A:11:81:A3:EE:8E:30:BD:64:99:17:47:F3:8B:82:09:42
```

### 2. Add SHA-1 to Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (dictionarydox)
3. Project Settings → Your apps → Android app
4. Add the SHA-1 fingerprint above
5. Download the updated `google-services.json`
6. Replace `android/app/google-services.json`

### 3. Verify Package Name
- Firebase: `app.dicitionarydox.uz`
- AndroidManifest.xml: `app.dicitionarydox.uz`
- ✅ Both match

---

## iOS Setup

### 1. GoogleService-Info.plist
✅ Already configured in `ios/Runner/GoogleService-Info.plist`

**Key values:**
- CLIENT_ID: `551056648202-sa56fq00eo9a4els0286vq8tc355trjd.apps.googleusercontent.com`
- REVERSED_CLIENT_ID: `com.googleusercontent.apps.551056648202-sa56fq00eo9a4els0286vq8tc355trjd`
- BUNDLE_ID: `app.dicitionarydox.uz`
- IS_SIGNIN_ENABLED: `true`

### 2. Info.plist Configuration
✅ Already configured with:
- Google Sign-In URL Scheme (CFBundleURLTypes)
- Uses REVERSED_CLIENT_ID from GoogleService-Info.plist

### 3. Build and Run
```bash
# Clean build
flutter clean
flutter pub get

# Run on iOS simulator
flutter run -d ios

# Or build for real device
flutter build ios
```

---

## Testing Google Sign-In

### Auth Flow:
1. **Splash Screen** → Checks auth state
2. **If not signed in** → Login Page
3. **Click "Sign in with Google"** → Google auth flow
4. **After successful sign-in** → Home Page
5. **On app restart** → Direct to Home Page (already signed in)

### Test on Android:
```bash
flutter run
```

### Test on iOS:
```bash
flutter run -d ios
```

### Test on Web:
```bash
flutter run -d chrome
```

---

## Troubleshooting

### Android Issues:
- Make sure SHA-1 is added to Firebase Console
- Verify `google-services.json` is updated
- Check package name matches in all places

### iOS Issues:
- Verify URL scheme in Info.plist matches REVERSED_CLIENT_ID
- Make sure GoogleService-Info.plist is in `ios/Runner/`
- Run `pod install` if needed (Flutter handles this automatically)

### Common Errors:
- **"API not enabled"**: Enable Google Sign-In API in Google Cloud Console
- **"Invalid client"**: SHA-1 or URL scheme mismatch
- **No response**: Check internet connection and Firebase configuration

---

## Files Modified

### Core Files:
- ✅ `lib/src/core/services/auth_service.dart` - Firebase Auth wrapper
- ✅ `lib/src/presentation/blocs/auth/` - Auth state management
- ✅ `lib/src/presentation/pages/login_page.dart` - Google Sign-In UI
- ✅ `lib/src/config/router.dart` - Auth guards
- ✅ `lib/src/presentation/pages/splash_screen.dart` - Auth check
- ✅ `lib/src/injector_container.dart` - DI setup

### Android Configuration:
- ✅ `android/app/google-services.json` - Firebase config
- ✅ `android/app/build.gradle.kts` - Google services plugin

### iOS Configuration:
- ✅ `ios/Runner/GoogleService-Info.plist` - Firebase config
- ✅ `ios/Runner/Info.plist` - URL scheme for Google Sign-In

### Dependencies:
- ✅ `pubspec.yaml` - firebase_auth, google_sign_in packages

---

## Next Steps

1. ✅ SHA-1 already in Firebase
2. ✅ iOS URL scheme configured
3. 🔄 Test on Android device
4. 🔄 Test on iOS device/simulator
5. 🔄 Add sign-out button to home page
6. 🔄 Display user profile (name, photo)

