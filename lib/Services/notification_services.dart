import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// INIT
  static Future<void> initialize() async {

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings, // ✅ FIXED
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // 👉 Handle notification click here if needed
        print("Notification clicked: ${response.payload}");
      },
    );
  }

  /// SHOW NOTIFICATION
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
  id: 0,
  title: title,
  body: body,
  notificationDetails: details,
);
  }
}