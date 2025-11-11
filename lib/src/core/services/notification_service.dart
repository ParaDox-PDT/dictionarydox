import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'web_notification_stub.dart'
    if (dart.library.html) 'web_notification_web.dart';

/// Background message handler - must be a top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Background message received: ${message.messageId}');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _isInitialized = false;

  /// Initialize notification service for all platforms
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permission
      await _requestPermission();

      // Initialize local notifications for Android and iOS
      if (!kIsWeb) {
        await _initializeLocalNotifications();
      }

      // Get FCM token
      await _getFCMToken();

      // Setup message handlers
      _setupMessageHandlers();

      _isInitialized = true;
      if (kDebugMode) {
        print('NotificationService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing NotificationService: $e');
      }
      rethrow;
    }
  }

  /// Request notification permission
  Future<void> _requestPermission() async {
    if (kIsWeb) {
      // Web platform
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        print('Web notification permission: ${settings.authorizationStatus}');
      }
    } else if (Platform.isIOS) {
      // iOS platform
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        print('iOS notification permission: ${settings.authorizationStatus}');
      }

      // Update APNs token for iOS
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (kDebugMode) {
        print('APNs token: $apnsToken');
      }
    } else if (Platform.isAndroid) {
      // Android 13+ requires runtime permission
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await androidImplementation?.requestNotificationsPermission();
      if (kDebugMode) {
        print('Android notification permission granted: $granted');
      }
    }
  }

  /// Initialize local notifications for Android and iOS
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // name
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      if (kIsWeb) {
        // Web requires VAPID key from Firebase Console
        // Get it from: Firebase Console -> Project Settings -> Cloud Messaging -> Web Push certificates
        _fcmToken = await _firebaseMessaging.getToken(
          vapidKey:
              'BL51l7sE79CYVJnBbij66Ivlhk1URhehq3XG59Sn0-m3Ybqoxw3IDodLmnlC-GpxUdIIt-E32sl4zRFpsQD13b0', // Replace with your VAPID key
        );
      } else {
        _fcmToken = await _firebaseMessaging.getToken();
      }

      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }

      // Listen to token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        if (kDebugMode) {
          print('FCM Token refreshed: $newToken');
        }
        // TODO: Send token to your server
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
    }
  }

  /// Setup message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Foreground message received: ${message.messageId}');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('Data: ${message.data}');
      }

      _messageStreamController.add(message);

      // Show local notification for foreground messages
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });

    // Handle message when app is opened from background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Message opened app: ${message.messageId}');
      }
      _messageStreamController.add(message);
      _handleNotificationTap(message);
    });

    // Check for initial message (app opened from terminated state)
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (kDebugMode) {
          print('Initial message: ${message.messageId}');
        }
        _messageStreamController.add(message);
        _handleNotificationTap(message);
      }
    });
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    if (kIsWeb) {
      // Show browser notification for web
      _showWebNotification(notification);
      return;
    }

    // Get image URL from notification (supports multiple formats)
    String? imageUrl =
        notification.android?.imageUrl ?? notification.apple?.imageUrl;

    // Fallback: check if image URL is in the main notification object
    // This handles Firebase's direct image field
    if (imageUrl == null) {
      // Try to get from notification's raw data
      final notificationData = message.toMap()['notification'] as Map?;
      imageUrl = notificationData?['image'] as String?;
    }

    // Download image if available
    String? bigPicturePath;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      bigPicturePath = await _downloadAndSaveImage(
        imageUrl,
        'notification_${notification.hashCode}',
      );
    }

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      // Show big picture if image is available
      styleInformation: bigPicturePath != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicturePath),
              contentTitle: notification.title,
              summaryText: notification.body,
              htmlFormatContentTitle: true,
              htmlFormatSummaryText: true,
            )
          : null,
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      attachments: bigPicturePath != null
          ? [
              DarwinNotificationAttachment(
                bigPicturePath,
              )
            ]
          : null,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
      payload: message.data.toString(),
    );
  }

  /// Download and save image for notification
  Future<String?> _downloadAndSaveImage(String url, String fileName) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Directory directory = Directory.systemTemp;
        final String filePath = '${directory.path}/$fileName.jpg';
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading image: $e');
      }
    }
    return null;
  }

  /// Show web notification using browser API
  void _showWebNotification(RemoteNotification notification) {
    showWebNotification(notification);
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
    // TODO: Navigate to specific screen based on payload
  }

  /// Handle notification tap from Firebase message
  void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('Handling notification tap: ${message.data}');
    }
    // TODO: Navigate to specific screen based on message data
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic: $e');
      }
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic: $e');
      }
    }
  }

  /// Dispose
  void dispose() {
    _messageStreamController.close();
  }
}
