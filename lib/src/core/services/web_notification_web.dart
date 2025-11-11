import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:universal_html/html.dart' as html;

/// Web implementation for showing browser notifications
void showWebNotification(RemoteNotification notification) {
  if (html.Notification.supported) {
    // Request permission if needed
    html.Notification.requestPermission().then((permission) {
      if (permission == 'granted') {
        html.Notification(
          notification.title ?? 'Notification',
          body: notification.body ?? '',
          icon: notification.android?.imageUrl ??
              notification.apple?.imageUrl ??
              '/icons/Icon-192.png',
        );
      }
    });
  }
}
