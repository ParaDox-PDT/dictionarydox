class AppConstants {
  // API Keys
  static const String pexelsApiKey =
      '2RXRA3lTBDPTwfTWcoKbMnxD7ZXXJAjsue6g4vTvgrdPpaewwAu27GzL';

  // API URLs
  static const String dictionaryApiBase =
      'https://api.dictionaryapi.dev/api/v2/entries/en';
  static const String pexelsApiBase = 'https://api.pexels.com/v1';

  // Firebase Web Configuration
  static const String firebaseWebApiKey = 'AIzaSyD8w-aOnHXDgPQ1u5DkgAh26BRUxBu5RmM';
  static const String firebaseWebAppId = '1:551056648202:web:e385fce0105249225117f3';
  static const String firebaseWebMessagingSenderId = '551056648202';
  static const String firebaseWebProjectId = 'dictionarydox';
  static const String firebaseWebAuthDomain = 'dictionarydox.firebaseapp.com';
  static const String firebaseWebStorageBucket = 'dictionarydox.appspot.com';
  static const String firebaseWebMeasurementId = 'G-NTCTYCF50F';

  // Firebase Android Configuration
  static const String firebaseAndroidApiKey = 'YOUR_ANDROID_API_KEY';
  static const String firebaseAndroidAppId = 'YOUR_ANDROID_APP_ID';
  static const String firebaseAndroidMessagingSenderId = 'YOUR_ANDROID_MESSAGING_SENDER_ID';
  static const String firebaseAndroidProjectId = 'YOUR_ANDROID_PROJECT_ID';
  static const String firebaseAndroidStorageBucket = 'YOUR_ANDROID_STORAGE_BUCKET';

  // Firebase iOS Configuration
  static const String firebaseIosApiKey = 'YOUR_IOS_API_KEY';
  static const String firebaseIosAppId = 'YOUR_IOS_APP_ID';
  static const String firebaseIosMessagingSenderId = 'YOUR_IOS_MESSAGING_SENDER_ID';
  static const String firebaseIosProjectId = 'YOUR_IOS_PROJECT_ID';
  static const String firebaseIosStorageBucket = 'YOUR_IOS_STORAGE_BUCKET';
  static const String firebaseIosClientId = 'YOUR_IOS_CLIENT_ID';
  static const String firebaseIosBundleId = 'YOUR_IOS_BUNDLE_ID';

  // Firebase macOS Configuration
  static const String firebaseMacosApiKey = 'YOUR_MACOS_API_KEY';
  static const String firebaseMacosAppId = 'YOUR_MACOS_APP_ID';
  static const String firebaseMacosMessagingSenderId = 'YOUR_MACOS_MESSAGING_SENDER_ID';
  static const String firebaseMacosProjectId = 'YOUR_MACOS_PROJECT_ID';
  static const String firebaseMacosStorageBucket = 'YOUR_MACOS_STORAGE_BUCKET';
  static const String firebaseMacosClientId = 'YOUR_MACOS_CLIENT_ID';
  static const String firebaseMacosBundleId = 'YOUR_MACOS_BUNDLE_ID';

  // Firebase Windows Configuration
  static const String firebaseWindowsApiKey = 'YOUR_WINDOWS_API_KEY';
  static const String firebaseWindowsAppId = 'YOUR_WINDOWS_APP_ID';
  static const String firebaseWindowsMessagingSenderId = 'YOUR_WINDOWS_MESSAGING_SENDER_ID';
  static const String firebaseWindowsProjectId = 'YOUR_WINDOWS_PROJECT_ID';
  static const String firebaseWindowsAuthDomain = 'YOUR_WINDOWS_AUTH_DOMAIN';
  static const String firebaseWindowsStorageBucket = 'YOUR_WINDOWS_STORAGE_BUCKET';
  static const String firebaseWindowsMeasurementId = 'YOUR_WINDOWS_MEASUREMENT_ID';

  // Hive Box Names
  static const String wordsBox = 'words';
  static const String unitsBox = 'units';

  // Limits
  static const int maxImages = 20;
  static const int maxDefinitions = 3;

  // Quiz Settings
  static const int distractorLetterCount = 4;
  static const int quizImageOptions = 4;

  // Animations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration feedbackDuration = Duration(seconds: 1);
}
