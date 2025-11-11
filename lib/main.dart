import 'package:dictionarydox/firebase_options.dart';
import 'package:dictionarydox/src/config/router.dart';
import 'package:dictionarydox/src/config/theme.dart';
import 'package:dictionarydox/src/core/services/notification_service.dart';
import 'package:dictionarydox/src/core/utils/platform_utils.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
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

  // Initialize dependencies
  await initDependencies();

  // Initialize notification service
  await NotificationService().initialize();

  runApp(const DictionaryDoxApp());
}

class DictionaryDoxApp extends StatelessWidget {
  const DictionaryDoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DictionaryDox',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
