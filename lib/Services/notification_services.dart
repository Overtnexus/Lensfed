import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// INITIALIZE LOCAL NOTIFICATION
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
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

    const NotificationDetails notificationDetails =
        NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  /// SAVE NOTIFICATION TO LOCAL STORAGE
  static Future<void> saveNotification({
    required String title,
    required String body,
    required String date,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> oldData =
        prefs.getStringList("notifications") ?? [];

    oldData.insert(
      0,
      jsonEncode({
        "title": title,
        "body": body,
        "date": date,
      }),
    );

    await prefs.setStringList(
      "notifications",
      oldData,
    );
  }

  /// GET SAVED NOTIFICATIONS
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data =
        prefs.getStringList("notifications") ?? [];

    return data
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }
}