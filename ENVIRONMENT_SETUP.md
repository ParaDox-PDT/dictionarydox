# Environment Setup Guide

This project uses environment variables to keep sensitive information secure. Follow these steps to configure your development environment.

## Quick Setup

1. **Copy the example environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Configure Firebase:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project or create a new one
   - Go to Project Settings → General
   - For each platform (Web, Android, iOS, macOS, Windows):
     - Click "Add app" if not already added
     - Copy the configuration values
     - Paste them into your `.env` file

3. **Configure Pexels API (Optional - for image search):**
   - Go to [Pexels API](https://www.pexels.com/api/)
   - Sign up and get your API key
   - Add it to `.env` as `PEXELS_API_KEY`

4. **Configure Web Firebase Messaging:**
   ```bash
   cp web/firebase-messaging-sw.js.example web/firebase-messaging-sw.js
   ```
   - Open `web/firebase-messaging-sw.js`
   - Replace placeholder values with your Firebase Web config

## Environment Variables

### Firebase Web Configuration
```
FIREBASE_WEB_API_KEY=your_web_api_key
FIREBASE_WEB_APP_ID=your_web_app_id
FIREBASE_WEB_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_WEB_PROJECT_ID=your_project_id
FIREBASE_WEB_AUTH_DOMAIN=your_auth_domain
FIREBASE_WEB_STORAGE_BUCKET=your_storage_bucket
FIREBASE_WEB_MEASUREMENT_ID=your_measurement_id
```

### Firebase Android Configuration
```
FIREBASE_ANDROID_API_KEY=your_android_api_key
FIREBASE_ANDROID_APP_ID=your_android_app_id
FIREBASE_ANDROID_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_ANDROID_PROJECT_ID=your_project_id
FIREBASE_ANDROID_STORAGE_BUCKET=your_storage_bucket
```

### Firebase iOS Configuration
```
FIREBASE_IOS_API_KEY=your_ios_api_key
FIREBASE_IOS_APP_ID=your_ios_app_id
FIREBASE_IOS_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_IOS_PROJECT_ID=your_project_id
FIREBASE_IOS_STORAGE_BUCKET=your_storage_bucket
FIREBASE_IOS_CLIENT_ID=your_ios_client_id
FIREBASE_IOS_BUNDLE_ID=your_ios_bundle_id
```

### Firebase macOS Configuration
```
FIREBASE_MACOS_API_KEY=your_macos_api_key
FIREBASE_MACOS_APP_ID=your_macos_app_id
FIREBASE_MACOS_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_MACOS_PROJECT_ID=your_project_id
FIREBASE_MACOS_STORAGE_BUCKET=your_storage_bucket
FIREBASE_MACOS_CLIENT_ID=your_macos_client_id
FIREBASE_MACOS_BUNDLE_ID=your_macos_bundle_id
```

### Firebase Windows Configuration
```
FIREBASE_WINDOWS_API_KEY=your_windows_api_key
FIREBASE_WINDOWS_APP_ID=your_windows_app_id
FIREBASE_WINDOWS_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_WINDOWS_PROJECT_ID=your_project_id
FIREBASE_WINDOWS_AUTH_DOMAIN=your_auth_domain
FIREBASE_WINDOWS_STORAGE_BUCKET=your_storage_bucket
FIREBASE_WINDOWS_MEASUREMENT_ID=your_measurement_id
```

### Pexels API (Optional)
```
PEXELS_API_KEY=your_pexels_api_key
```
Get your key from: https://www.pexels.com/api/

### Dictionary API
```
DICTIONARY_API_BASE_URL=https://api.dictionaryapi.dev/api/v2/entries/en
```
This API is free and doesn't require a key.

## Security Notes

⚠️ **IMPORTANT:**
- Never commit `.env` file to version control
- Never commit `web/firebase-messaging-sw.js` with real credentials
- The `.gitignore` file is configured to exclude these files
- Only commit `.env.example` and `web/firebase-messaging-sw.js.example`

## Troubleshooting

### App won't start
- Make sure `.env` file exists in the project root
- Verify all required Firebase variables are set
- Run `flutter clean` and `flutter pub get`

### Image search not working
- Check if `PEXELS_API_KEY` is set in `.env`
- Verify your Pexels API key is valid
- Check your API usage limits

### Firebase errors
- Verify all Firebase config values are correct
- Make sure `web/firebase-messaging-sw.js` is configured for web
- Check Firebase Console for any project issues

## Getting Firebase Configuration

### Web App
1. Firebase Console → Project Settings
2. Your apps → Web app
3. Config object contains all needed values

### Android App
1. Firebase Console → Project Settings
2. Your apps → Android app
3. Download `google-services.json` (still needed for native config)
4. Values are in the JSON file

### iOS/macOS App
1. Firebase Console → Project Settings
2. Your apps → iOS app
3. Download `GoogleService-Info.plist` (still needed for native config)
4. Values are in the plist file

## Next Steps

After configuring environment variables:
```bash
flutter pub get
flutter run
```
