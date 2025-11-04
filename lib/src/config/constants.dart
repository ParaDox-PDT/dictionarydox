class AppConstants {
  // API Keys
  static const String pexelsApiKey =
      '2RXRA3lTBDPTwfTWcoKbMnxD7ZXXJAjsue6g4vTvgrdPpaewwAu27GzL'; // Replace with actual key

  // API URLs
  static const String dictionaryApiBase =
      'https://api.dictionaryapi.dev/api/v2/entries/en';
  static const String pexelsApiBase = 'https://api.pexels.com/v1';

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
