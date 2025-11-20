import 'package:dictionarydox/firebase_options.dart';
import 'package:dictionarydox/src/config/router.dart';
import 'package:dictionarydox/src/config/theme.dart';
import 'package:dictionarydox/src/core/providers/initialization_provider.dart';
import 'package:dictionarydox/src/core/services/notification_service.dart';
import 'package:dictionarydox/src/core/utils/platform_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (required for auth and firestore)
  // On Android, Firebase might be auto-initialized by google-services.json,
  // so we need to handle the duplicate-app error gracefully
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    // Handle Firebase-specific errors
    if (e.code == 'duplicate-app' || e.message?.contains('duplicate-app') == true) {
      // Firebase is already initialized, continue normally
      if (kDebugMode) {
        print('Firebase already initialized (auto-initialized by native code)');
      }
    } else {
      // Some other Firebase error occurred, rethrow it
      rethrow;
    }
  } on PlatformException catch (e) {
    // Handle PlatformException from native code (Android/iOS)
    if (e.code == 'duplicate-app' || 
        e.message?.contains('duplicate-app') == true ||
        e.message?.contains('[core/duplicate-app]') == true) {
      // Firebase is already initialized, continue normally
      if (kDebugMode) {
        print('Firebase already initialized (auto-initialized by native code)');
      }
    } else {
      // Some other PlatformException occurred, rethrow it
      rethrow;
    }
  } catch (e) {
    // Handle other errors
    final errorString = e.toString();
    if (errorString.contains('duplicate-app') || 
        errorString.contains('[core/duplicate-app]')) {
      // Firebase is already initialized, continue normally
      if (kDebugMode) {
        print('Firebase already initialized (auto-initialized by native code)');
      }
    } else {
      // Some other error occurred, rethrow it
      rethrow;
    }
  }

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
