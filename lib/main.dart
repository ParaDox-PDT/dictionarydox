import 'package:dictionarydox/firebase_options.dart';
import 'package:dictionarydox/src/config/router.dart';
import 'package:dictionarydox/src/config/theme.dart';
import 'package:dictionarydox/src/core/providers/initialization_provider.dart';
import 'package:dictionarydox/src/core/services/notification_service.dart';
import 'package:dictionarydox/src/core/utils/platform_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universal_html/html.dart' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (skip on web, loaded from HTML instead)
  if (!PlatformUtils.isWeb) {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      // .env file might not exist, continue anyway
      debugPrint('Warning: Could not load .env file: $e');
    }
  } else {
    // On web, environment variables are loaded from index.html via window.flutterEnv
    // Load them into dotenv for compatibility
    try {
      // Get environment variables from window.flutterEnv (set in index.html)
      final window = html.window as dynamic;
      if (window.flutterEnv != null) {
        final env = window.flutterEnv as Map<String, dynamic>;
        
        // Load Pexels API key if available
        if (env['PEXELS_API_KEY'] != null && env['PEXELS_API_KEY'].toString().isNotEmpty) {
          dotenv.env['PEXELS_API_KEY'] = env['PEXELS_API_KEY'].toString();
          debugPrint('Web: Pexels API key loaded from window.flutterEnv');
        } else {
          debugPrint('Web: PEXELS_API_KEY not found or empty in window.flutterEnv');
        }
      } else {
        debugPrint('Web: window.flutterEnv not found - image search will not work without API key');
      }
    } catch (e) {
      debugPrint('Warning: Could not load environment variables on web: $e');
    }
  }

  // Initialize Firebase (required for auth and firestore)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Configure system UI only for non-web platforms
  if (!PlatformUtils.isWeb) {
    // Configure system UI for edge-to-edge display
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    // Set transparent system navigation bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // Start app immediately - initialize dependencies in background
  runApp(const DictionaryDoxApp());
}

class DictionaryDoxApp extends StatelessWidget {
  const DictionaryDoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return InitializationProvider(
      initialization: InitializationProvider.initialize(),
      child: MaterialApp.router(
        title: 'DictionaryDox',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: router,
        builder: (context, child) {
          return SafeArea(
            top: false,
            bottom: true,
            child: child ?? const SizedBox(),
          );
        },
      ),
    );
  }
}
