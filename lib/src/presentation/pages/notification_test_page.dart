import 'package:dictionarydox/src/core/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  final NotificationService _notificationService = NotificationService();
  String _fcmToken = 'Loading...';
  final List<RemoteMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
    _listenToMessages();
  }

  void _loadToken() {
    setState(() {
      _fcmToken = _notificationService.fcmToken ?? 'No token yet';
    });
  }

  void _listenToMessages() {
    _notificationService.messageStream.listen((message) {
      setState(() {
        _messages.insert(0, message);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.notification?.title ?? 'New message'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _copyToken() {
    Clipboard.setData(ClipboardData(text: _fcmToken));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('FCM token copied to clipboard'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FCM Token section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'FCM Token',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: _copyToken,
                          tooltip: 'Copy token',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _fcmToken,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Topic subscription section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Topic Subscription',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _notificationService
                                  .subscribeToTopic('all_users');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Subscribed to "all_users"'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Subscribe to "all_users"'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _notificationService
                                  .unsubscribeFromTopic('all_users');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Unsubscribed from "all_users"'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Unsubscribe'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Messages section
            const Text(
              'Received Messages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet.\nSend a test notification from Firebase Console.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.notifications),
                            title: Text(
                              message.notification?.title ?? 'No title',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message.notification?.body != null)
                                  Text(message.notification!.body!),
                                if (message.data.isNotEmpty)
                                  Text(
                                    'Data: ${message.data}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Text(
                              message.sentTime?.toString().substring(11, 19) ??
                                  '',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
