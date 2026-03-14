
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lensfed/Modals/notification_modal.dart';
import 'package:lensfed/Services/api_services.dart';


class NotificationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
   String? _message;
  String? get message => _message;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

Future<void> loadNotifications(String role) async {
  try {

    _isLoading = true;
    notifyListeners();

    final snapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .where("isSent", isEqualTo: true) // ✅ only sent notifications
        .where("role", whereIn: [role, "All"]) // ✅ role match
        .orderBy("created_at", descending: true)
        .get();

    _notifications = snapshot.docs
        .map((doc) => NotificationModel.fromJson(doc.data()))
        .toList();

  } catch (e) {
    print("Notification error: $e");
  }

  _isLoading = false;
  notifyListeners();
}


  // FETCH ALL UNITS
  Future<void> fetchNotification() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getNotification();
      _notifications = response.map((e) => NotificationModel.fromJson(e)).toList();
    } catch (e) {
      _message = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
void saveDeviceToken(String token) {

  print("Saving token: $token");

  // Save token to Firestore or backend API
}
void addNotificationFromPush(RemoteMessage message) {

  notifications.insert(
    0,
    NotificationModel(
      title: message.notification?.title,
      message: message.notification?.body,
      createDateTime: DateTime.now().toString(),
    ),
  );

  notifyListeners();
}
void openNotification(RemoteMessage message) {

  // Navigate to notification screen if needed
}
}
